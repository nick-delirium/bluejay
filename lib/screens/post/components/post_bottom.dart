import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    super.key,
    required this.isExpanded,
    required this.linkFlairBackgroundColor,
    required this.linkFlairText,
    required this.score,
    required this.upvoteRatio,
  });

  final String? linkFlairBackgroundColor;
  final String? linkFlairText;
  final int score;
  final bool isExpanded;
  final String upvoteRatio;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var formatter = NumberFormat.compact();
    Color flairColor = linkFlairBackgroundColor != null
        ? Color(int.parse("FF${linkFlairBackgroundColor!.replaceAll('#', '')}",
            radix: 16))
        : theme.colorScheme.background;
    return Row(
      children: [
        if (linkFlairText != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: flairColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              child: Text(
                linkFlairText!,
                style: TextStyle(
                    color: flairColor.computeLuminance() > 0.4
                        ? Colors.black
                        : Colors.white),
              ),
            ),
          ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
            child: Icon(
              Icons.thumb_up_alt,
              color: theme.colorScheme.onPrimary,
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
    );
  }
}
