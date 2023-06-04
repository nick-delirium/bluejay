import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_comment.dart';
import 'package:share_plus/share_plus.dart';

class CommentBottom extends StatelessWidget {
  const CommentBottom({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share("https://reddit.com${comment.permalink}");
          },
        ),
        Spacer(),
        Icon(Icons.arrow_drop_down),
        Text(comment.score.toString()),
        Icon(Icons.arrow_drop_up),
      ],
    );
  }
}
