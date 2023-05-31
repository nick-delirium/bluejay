import 'package:flutter/material.dart';
import 'package:bluejay/utils/time.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.subreddit,
    required this.createdAt,
    required this.title,
    required this.author,
    required this.isExpanded,
  });

  final String subreddit;
  final int createdAt;
  final String title;
  final String author;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "in ",
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
            ),
            Text(subreddit),
            Spacer(),
            Text(
              fullDateFromMs(createdAt),
              style: TextStyle(fontWeight: FontWeight.w200),
            )
          ],
        ),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 18)),
        if (isExpanded)
          Row(
            children: [
              Text(
                "by ",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
              ),
              Text('u/$author'),
            ],
          )
      ],
    );
  }
}
