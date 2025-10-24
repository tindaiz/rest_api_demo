
import 'package:flutter/material.dart';
import '../models/post_model.dart';

typedef OnTapPost = void Function(Post post);

class PostCard extends StatelessWidget {
  final Post post;
  final OnTapPost? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        onTap: onTap == null ? null : () => onTap!(post),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(post.id.toString(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
