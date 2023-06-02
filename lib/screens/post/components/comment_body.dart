import 'package:bluejay/utils/time.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_comment.dart';
import 'dart:math';

class CommentBody extends StatelessWidget {
  const CommentBody({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var subCommentColor = rainbow();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "u/${comment.author}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              fullDateFromMs(comment.createdAt),
              style: TextStyle(fontWeight: FontWeight.w200),
            )
          ],
        ),
        Html(
          data: comment.body,
          onLinkTap: (url, context, attributes, element) {
            print(url);
          },
          onImageTap: (url, context, attributes, element) {
            print(url);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
          onCssParseError: (css, messages) {
            print("css that errored: $css");
            print("error messages:");
            for (var element in messages) {
              print(element);
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.arrow_drop_down),
            Text(comment.score.toString()),
            Icon(Icons.arrow_drop_up),
          ],
        ),
        if (comment.replies.isNotEmpty || comment.hiddenReplies != null)
          Container(
            decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: subCommentColor, width: 2))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 0, 0),
              child: comment.replies.isNotEmpty
                  ? Column(
                      children: [
                        for (var subComment in comment.replies)
                          CommentBody(
                            comment: subComment,
                          )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${comment.hiddenReplies} skipped',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}

Color rainbow() {
  final colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
    Colors.lightBlue,
    Colors.blueGrey
  ];
  final random = Random();
  final index = random.nextInt(colors.length);
  return colors[index];
}
