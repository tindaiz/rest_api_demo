
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_http_service.dart';
import '../services/api_dio_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? postToEdit;
  final bool useDio; // true => use Dio, false => use Http

  const PostFormScreen({super.key, this.postToEdit, this.useDio = true});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  final _http = ApiHttpService();
  final _dio = ApiDioService();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.postToEdit != null) {
      _titleCtrl.text = widget.postToEdit!.title;
      _bodyCtrl.text = widget.postToEdit!.body;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    try {
      if (widget.postToEdit == null) {
        // Create
        final newPost = Post(id: 0, title: title, body: body);
        final created = widget.useDio ? await _dio.createPost(newPost) : await _http.createPost(newPost);
        Navigator.of(context).pop({'action': 'created', 'post': created});
      } else {
        final editing = widget.postToEdit!.copyWith(title: title, body: body);
        final updated = widget.useDio ? await _dio.updatePost(editing) : await _http.updatePost(editing);
        Navigator.of(context).pop({'action': 'updated', 'post': updated});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmDelete() async {
    if (widget.postToEdit == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có muốn xóa bài viết này?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Xóa')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);
    try {
      final id = widget.postToEdit!.id;
      if (widget.useDio) {
        await _dio.deletePost(id);
      } else {
        await _http.deletePost(id);
      }
      Navigator.of(context).pop({'action': 'deleted', 'id': id});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.postToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Chỉnh sửa bài viết' : 'Tạo bài viết'),
        backgroundColor: widget.useDio ? Colors.green : Colors.blue,
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _loading ? null : _confirmDelete,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Tiêu đề', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bodyCtrl,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(labelText: 'Nội dung', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập nội dung' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.useDio ? Colors.green : Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(isEdit ? 'Cập nhật' : 'Tạo', style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
