import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_comment.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bluejay/reddit_library/reddit.dart';
import 'package:bluejay/screens/post/post_state.dart';
import 'package:bluejay/components/rating.dart';

class CommentBottom extends StatelessWidget {
  const CommentBottom({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    var postState = context.watch<PostState>();

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share("https://reddit.com${comment.permalink}");
          },
        ),
        Spacer(),
        Rating(
            voteDir: comment.upvoteDir,
            onUp: () => postState.commentVote(comment,
                comment.upvoteDir == VoteDir.up ? VoteDir.neutral : VoteDir.up),
            onDown: () => postState.commentVote(
                comment,
                comment.upvoteDir == VoteDir.down
                    ? VoteDir.neutral
                    : VoteDir.down),
            score: comment.score)
      ],
    );
  }
}
