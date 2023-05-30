import 'components/post_selftext.dart';
import 'components/post_bottom.dart';
import 'components/post_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'post_state.dart';

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
    return Container(
      color: theme.primaryColorDark,
      padding: EdgeInsets.all(8),
      margin: widget.isExpanded ? EdgeInsets.symmetric(vertical: 6) : null,
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
              subreddit: usedPost.subreddit, createdAt: usedPost.createdAt),
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usedPost.title, style: TextStyle(fontSize: 16)),
                  if (usedPost.selftext != null)
                    PostSelfText(
                        text: usedPost.selftext!,
                        isExpanded: widget.isExpanded),
                ],
              )),
              if (usedPost.thumbnail != null &&
                  showThumbNail(usedPost.postType))
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: Image.network(
                      usedPost.thumbnail!,
                      semanticLabel: 'Post Thumbnail',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
            ],
          ),
          PostBottom(post: usedPost, isExpanded: widget.isExpanded),
        ],
      )),
    );
  }
}

bool showThumbNail(PostType postType) {
  return [PostType.link, PostType.text].contains(postType);
}
