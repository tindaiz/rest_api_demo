
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_dio_service.dart';
import '../widgets/post_card.dart';
import 'post_form_screen.dart';

class PostListDio extends StatefulWidget {
  const PostListDio({super.key});

  @override
  State<PostListDio> createState() => _PostListDioState();
}

class _PostListDioState extends State<PostListDio> {
  final _api = ApiDioService();
  List<Post> _posts = [];
  List<Post> _filtered = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await _api.getPosts();
      setState(() {
        _posts = data;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filtered = [..._posts];
    } else {
      _filtered = _posts.where((p) => p.title.toLowerCase().contains(_query.toLowerCase())).toList();
    }
  }

  Future<void> _openForm({Post? post}) async {
    final res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PostFormScreen(postToEdit: post, useDio: true),
    ));
    if (res != null && mounted) {
      if (res['action'] == 'created') {
        setState(() => _posts.insert(0, res['post'] as Post));
        _applyFilter();
      } else if (res['action'] == 'updated') {
        final updated = res['post'] as Post;
        final idx = _posts.indexWhere((p) => p.id == updated.id);
        if (idx >= 0) {
          setState(() {
            _posts[idx] = updated;
            _applyFilter();
          });
        }
      } else if (res['action'] == 'deleted') {
        final id = res['id'] as int;
        setState(() {
          _posts.removeWhere((p) => p.id == id);
          _applyFilter();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm theo tiêu đề', border: OutlineInputBorder()),
                    onChanged: (v) {
                      setState(() {
                        _query = v;
                        _applyFilter();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: _filtered.isEmpty
                        ? ListView(
                            children: const [Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Không có bài viết')))],
                          )
                        : ListView.builder(
                            itemCount: _filtered.length,
                            itemBuilder: (c, i) {
                              final p = _filtered[i];
                              return PostCard(
                                post: p,
                                onTap: (post) => _openForm(post: post),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
