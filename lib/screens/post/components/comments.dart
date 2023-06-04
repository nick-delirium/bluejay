import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejay/screens/post/post_state.dart';
import 'comment_body.dart';

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
      padding: EdgeInsets.only(top: 8),
      child: postState.isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 42.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: postState.comments.length,
              itemBuilder: (context, index) {
                var comment = postState.comments.elementAt(index);
                return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: theme.colorScheme.onBackground))),
                    child: CommentBody(
                      comment: comment,
                      level: 1,
                    ));
              }),
    );
  }
}
