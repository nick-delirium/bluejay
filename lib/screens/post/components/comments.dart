import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejay/screens/post/post_state.dart';
import 'package:bluejay/types/reddit_comment.dart';
import 'dart:math';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => CommentsViewState();
}

class CommentsViewState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var postState = context.watch<PostState>();
    return Container(
      child: postState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postState.comments.length,
                  itemBuilder: (context, index) {
                    var comment = postState.comments.elementAt(index);
                    return Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: theme.colorScheme.onBackground))),
                        child: CommentBody(
                          comment: comment,
                        ));
                  }),
            ),
    );
  }
}

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
        Text(
          "u/${comment.author}",
          style: TextStyle(fontWeight: FontWeight.w500),
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
              padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
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
