import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejay/screens/post/post_state.dart';
import 'package:bluejay/types/reddit_comment.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => CommentsViewState();
}

class CommentsViewState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    var postState = context.watch<PostState>();
    return Container(
      color: Colors.white10,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: postState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                for (var comment in postState.comments)
                  Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(6),
                      child: CommentBody(
                        comment: comment,
                      ))
              ],
            ),
    );
  }
}

class CommentBody extends StatelessWidget {
  const CommentBody({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(comment.author),
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
        Text(comment.score.toString()),
      ],
    );
  }
}
