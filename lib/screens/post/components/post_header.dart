import 'package:flutter/material.dart';
import 'package:bluejay/utils/time.dart';
import 'post_flair.dart';
import 'package:bluejay/types/reddit_post.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.subreddit,
    required this.createdAt,
    required this.title,
    required this.author,
    required this.isExpanded,
    required this.postType,
    this.linkFlairBackgroundColor,
    this.linkFlairText,
  });

  final String subreddit;
  final int createdAt;
  final String title;
  final String author;
  final bool isExpanded;
  final PostType postType;
  final String? linkFlairBackgroundColor;
  final String? linkFlairText;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Color flairColor = linkFlairBackgroundColor != null
        ? Color(int.parse("FF${linkFlairBackgroundColor!.replaceAll('#', '')}",
            radix: 16))
        : theme.colorScheme.background;
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
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
                fullDateFromMs(createdAt, false),
                style: TextStyle(fontWeight: FontWeight.w200),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                PostFlair(
                    flairColor: theme.colorScheme.onSurface,
                    linkFlairText: enumToString(postType)),
                if (linkFlairText != null)
                  PostFlair(
                      flairColor: flairColor, linkFlairText: linkFlairText),
              ],
            ),
          ),
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
      ),
    );
  }
}

String enumToString(PostType value) {
  return value.toString().split('.').last.toUpperCase();
}
