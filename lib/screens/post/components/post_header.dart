import 'package:flutter/material.dart';
import 'package:bluejay/utils/time.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.subreddit,
    required this.createdAt,
  });

  final String subreddit;
  final int createdAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "in ",
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
        ),
        Text(subreddit),
        SizedBox(width: 4),
        Spacer(),
        Text(
          fullDateFromMs(createdAt),
          style: TextStyle(fontWeight: FontWeight.w200),
        )
      ],
    );
  }
}
