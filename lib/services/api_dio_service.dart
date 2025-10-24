
import 'package:dio/dio.dart';
import '../models/post_model.dart';

class ApiDioService {
  final Dio dio;

  ApiDioService({Dio? client}) : dio = client ?? Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com')) {
    // Interceptor: log requests/responses/errors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // simple logging
        print('➡️ [DIO] ${options.method} ${options.path} - query: ${options.queryParameters} - data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [DIO] ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (err, handler) {
        print('❌ [DIO] ${err.response?.statusCode} ${err.message}');
        return handler.next(err);
      },
    ));
  }

  Future<List<Post>> getPosts() async {
    final res = await dio.get('/posts');
    if (res.statusCode == 200) {
      final List data = res.data as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Dio GET failed: ${res.statusCode}');
    }
  }

  Future<Post> createPost(Post post) async {
    final res = await dio.post('/posts', data: {'title': post.title, 'body': post.body});
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Post.fromJson(res.data);
    } else {
      throw Exception('Dio POST failed: ${res.statusCode}');
    }
  }

  Future<Post> updatePost(Post post) async {
    final res = await dio.put('/posts/${post.id}', data: {'id': post.id, 'title': post.title, 'body': post.body});
    if (res.statusCode == 200) {
      return Post.fromJson(res.data);
    } else {
      throw Exception('Dio PUT failed: ${res.statusCode}');
    }
  }

  Future<void> deletePost(int id) async {
    final res = await dio.delete('/posts/$id');
    if (res.statusCode == 200 || res.statusCode == 204) {
      return;
    } else {
      throw Exception('Dio DELETE failed: ${res.statusCode}');
    }
  }
}
