
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiHttpService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    final res = await http.get(Uri.parse('$_baseUrl/posts'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('HTTP GET failed: ${res.statusCode}');
    }
  }

  Future<Post> createPost(Post post) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': post.title, 'body': post.body}),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Post.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('HTTP POST failed: ${res.statusCode}');
    }
  }

  Future<Post> updatePost(Post post) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id': post.id, 'title': post.title, 'body': post.body}),
    );
    if (res.statusCode == 200) {
      return Post.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('HTTP PUT failed: ${res.statusCode}');
    }
  }

  Future<void> deletePost(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/posts/$id'));
    if (res.statusCode == 200 || res.statusCode == 204) {
      return;
    } else {
      throw Exception('HTTP DELETE failed: ${res.statusCode}');
    }
  }
}
