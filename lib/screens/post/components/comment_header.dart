import 'package:bluejay/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_comment.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "u/${comment.author}",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          fullDateFromMs(comment.createdAt, false),
          style: TextStyle(fontWeight: FontWeight.w200),
        )
      ],
    );
  }
}
