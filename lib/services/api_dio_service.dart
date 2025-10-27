

import 'package:dio/dio.dart';
import '../models/post_model.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      for (var i = 0; i < retries; i++) {
        try {
          await Future.delayed(retryDelay);
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          if (i == retries - 1) return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout;
  }
}

class ApiDioService {
  final Dio dio;

  ApiDioService({Dio? client})
      : dio = client ?? Dio(BaseOptions(
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        )) {
    // Logging interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('➡️ [DIO] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [DIO] ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (err, handler) {
        print('❌ [DIO] ${err.type} ${err.message}');
        return handler.next(err);
      },
    ));

    // Thêm retry interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));
  }

  Future<List<Post>> getPosts({CancelToken? cancelToken}) async {
    final res = await dio.get('/posts', cancelToken: cancelToken);
    if (res.statusCode == 200) {
      final List data = res.data as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Dio GET failed: ${res.statusCode}');
    }
  }

  Future<Post> createPost(Post post, {CancelToken? cancelToken}) async {
    final res = await dio.post('/posts',
        data: {'title': post.title, 'body': post.body},
        cancelToken: cancelToken);
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Post.fromJson(res.data);
    } else {
      throw Exception('Dio POST failed: ${res.statusCode}');
    }
  }

  Future<Post> updatePost(Post post, {CancelToken? cancelToken}) async {
    final res = await dio.put('/posts/${post.id}',
        data: {'id': post.id, 'title': post.title, 'body': post.body},
        cancelToken: cancelToken);
    if (res.statusCode == 200) {
      return Post.fromJson(res.data);
    } else {
      throw Exception('Dio PUT failed: ${res.statusCode}');
    }
  }

  Future<void> deletePost(int id, {CancelToken? cancelToken}) async {
    final res = await dio.delete('/posts/$id', cancelToken: cancelToken);
    if (res.statusCode == 200 || res.statusCode == 204) {
      print('✅ Post $id deleted');
    } else {
      throw Exception('Dio DELETE failed: ${res.statusCode}');
    }
  }
}
