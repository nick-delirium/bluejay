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

    if (usedPost.postType == PostType.link) {
      print('POST LINK ${usedPost.title} ${usedPost.url}');
    }
    if (usedPost.images.length > 1 || usedPost.isGallery == true) {
      print('GALLERY  ${usedPost.title}');
    }
    if (widget.isExpanded) {
      return ExpandedPost(
          theme: theme, usedPost: usedPost, upvoteRatio: upvoteRatio);
    } else {
      return FeedPost(
          theme: theme, usedPost: usedPost, upvoteRatio: upvoteRatio);
    }
  }
}

class FeedPost extends StatelessWidget {
  const FeedPost({
    super.key,
    required this.theme,
    required this.usedPost,
    required this.upvoteRatio,
  });

  final ThemeData theme;
  final Post usedPost;
  final String upvoteRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surface,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            subreddit: usedPost.subreddit,
            createdAt: usedPost.createdAt,
            isExpanded: false,
            author: usedPost.author,
            title: usedPost.title,
          ),
          SizedBox(
            height: 3,
          ),
          if (usedPost.selftext != null || usedPost.thumbnail != null)
            PostBody(
              postType: usedPost.postType,
              isExpanded: false,
              thumbnail: usedPost.thumbnail,
              selftext: usedPost.selftext,
              images: usedPost.images,
              postUrl: usedPost.url,
            ),
          PostBottom(
              postType: usedPost.postType,
              isExpanded: false,
              score: usedPost.score,
              linkFlairBackgroundColor: usedPost.linkFlairBackgroundColor,
              linkFlairText: usedPost.linkFlairText,
              upvoteRatio: upvoteRatio),
        ],
      )),
    );
  }
}

class ExpandedPost extends StatelessWidget {
  const ExpandedPost({
    super.key,
    required this.theme,
    required this.usedPost,
    required this.upvoteRatio,
  });

  final ThemeData theme;
  final Post usedPost;
  final String upvoteRatio;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          color: theme.colorScheme.surface,
          margin: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(
                subreddit: usedPost.subreddit,
                createdAt: usedPost.createdAt,
                isExpanded: true,
                author: usedPost.author,
                title: usedPost.title,
              ),
              if (usedPost.selftext != null ||
                  usedPost.thumbnail != null ||
                  usedPost.images.isNotEmpty)
                PostBody(
                  postType: usedPost.postType,
                  isExpanded: true,
                  thumbnail: usedPost.thumbnail,
                  selftext: usedPost.selftext,
                  postUrl: usedPost.url,
                  images: usedPost.images,
                ),
              PostBottom(
                  postType: usedPost.postType,
                  isExpanded: true,
                  score: usedPost.score,
                  linkFlairBackgroundColor: usedPost.linkFlairBackgroundColor,
                  linkFlairText: usedPost.linkFlairText,
                  upvoteRatio: upvoteRatio),
              Comments(),
            ],
          ),
        ),
      ),
    );
  }
}
