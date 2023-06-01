import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'post_state.dart';
import 'components/post_bottom.dart';
import 'components/post_header.dart';
import 'components/post_body.dart';
import 'components/comments.dart';

class RedditPostView extends StatefulWidget {
  const RedditPostView({super.key, required this.isExpanded, this.post});

  final Post? post;
  final bool isExpanded;

  @override
  State<RedditPostView> createState() => _RedditPostViewState();
}

class _RedditPostViewState extends State<RedditPostView> {
  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var postState = Provider.of<PostState>(context, listen: false);
        await postState.fetchComments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var postState = context.watch<PostState>();

    Post usedPost = widget.post ?? postState.currentPost!;
    String upvoteRatio = "${usedPost.upvoteRatio * 100}%";
    if (widget.isExpanded) {
      print('Im expanded');
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            color: theme.colorScheme.surface,
            margin:
                widget.isExpanded ? null : EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(
                  subreddit: usedPost.subreddit,
                  createdAt: usedPost.createdAt,
                  isExpanded: widget.isExpanded,
                  author: usedPost.author,
                  title: usedPost.title,
                ),
                SizedBox(
                  height: 3,
                ),
                if (usedPost.selftext != null || usedPost.thumbnail != null)
                  PostBody(
                    postType: usedPost.postType,
                    isExpanded: widget.isExpanded,
                    thumbnail: usedPost.thumbnail,
                    selftext: usedPost.selftext,
                  ),
                PostBottom(
                    isExpanded: widget.isExpanded,
                    score: usedPost.score,
                    linkFlairBackgroundColor: usedPost.linkFlairBackgroundColor,
                    linkFlairText: usedPost.linkFlairText,
                    upvoteRatio: upvoteRatio),
                if (widget.isExpanded) Comments(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: theme.colorScheme.surface,
        margin: widget.isExpanded ? null : EdgeInsets.symmetric(vertical: 6),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              subreddit: usedPost.subreddit,
              createdAt: usedPost.createdAt,
              isExpanded: widget.isExpanded,
              author: usedPost.author,
              title: usedPost.title,
            ),
            SizedBox(
              height: 3,
            ),
            if (usedPost.selftext != null || usedPost.thumbnail != null)
              PostBody(
                postType: usedPost.postType,
                isExpanded: widget.isExpanded,
                thumbnail: usedPost.thumbnail,
                selftext: usedPost.selftext,
              ),
            PostBottom(
                isExpanded: widget.isExpanded,
                score: usedPost.score,
                linkFlairBackgroundColor: usedPost.linkFlairBackgroundColor,
                linkFlairText: usedPost.linkFlairText,
                upvoteRatio: upvoteRatio),
          ],
        )),
      );
    }
  }
}