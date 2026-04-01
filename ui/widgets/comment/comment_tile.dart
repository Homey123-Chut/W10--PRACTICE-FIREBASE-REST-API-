import 'package:flutter/material.dart';
import 'package:w10/model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.comment),
      title: Text(comment.text),
    );
  }
}