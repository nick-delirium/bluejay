import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'post_flair.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    super.key,
    required this.isExpanded,
    required this.linkFlairBackgroundColor,
    required this.linkFlairText,
    required this.score,
    required this.upvoteRatio,
    required this.postType,
  });

  final String? linkFlairBackgroundColor;
  final String? linkFlairText;
  final int score;
  final bool isExpanded;
  final String upvoteRatio;
  final PostType postType;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var formatter = NumberFormat.compact();

    Color flairColor = linkFlairBackgroundColor != null
        ? Color(int.parse("FF${linkFlairBackgroundColor!.replaceAll('#', '')}",
            radix: 16))
        : theme.colorScheme.background;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 2, color: theme.colorScheme.onSurface))),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PostFlair(
                    flairColor: theme.colorScheme.onSurface,
                    linkFlairText: enumToString(postType)),
              ),
              if (linkFlairText != null)
                PostFlair(flairColor: flairColor, linkFlairText: linkFlairText),
            ],
          ),
          Row(
            children: [
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
                  child: Icon(
                    Icons.thumb_up_alt,
                    color: theme.colorScheme.primary,
                    semanticLabel: 'Upvote ratio',
                    size: 18,
                  ),
                ),
              if (isExpanded) Text(upvoteRatio, style: TextStyle(fontSize: 14)),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  semanticLabel: 'Downvote',
                ),
                padding: EdgeInsets.all(0),
                iconSize: 28,
                enableFeedback: true,
                onPressed: () {
                  print('down');
                  HapticFeedback.vibrate();
                },
              ),
              Text(formatter.format(score)),
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_up,
                  semanticLabel: 'Upvote',
                ),
                padding: EdgeInsets.all(0),
                iconSize: 28,
                enableFeedback: true,
                onPressed: () {
                  print('up');
                  HapticFeedback.lightImpact();
                },
              ),
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
