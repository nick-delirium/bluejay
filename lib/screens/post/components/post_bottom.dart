import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    super.key,
    required this.post,
    required this.isExpanded,
  });

  final Post post;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var formatter = NumberFormat.compact();
    Color flairColor = post.linkFlairBackgroundColor != null
        ? Color(int.parse(
            "FF${post.linkFlairBackgroundColor!.replaceAll('#', '')}",
            radix: 16))
        : theme.colorScheme.background;
    return Row(
      children: [
        if (isExpanded)
          Text(
            "by ",
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
          ),
        if (isExpanded) Text('u/${post.author}'),
        if (post.linkFlairText != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: flairColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              child: Text(
                post.linkFlairText!,
                style: TextStyle(
                    color: flairColor.computeLuminance() > 0.4
                        ? Colors.black
                        : Colors.white),
              ),
            ),
          ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          padding: EdgeInsets.all(0),
          iconSize: 28,
          enableFeedback: true,
          onPressed: () {
            print('down');
            HapticFeedback.vibrate();
          },
        ),
        Text(formatter.format(post.score)),
        IconButton(
          icon: Icon(Icons.arrow_drop_up),
          padding: EdgeInsets.all(0),
          iconSize: 28,
          enableFeedback: true,
          onPressed: () {
            print('up');
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }
}
