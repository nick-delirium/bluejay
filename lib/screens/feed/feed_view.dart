import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feed_state.dart';
import 'package:bluejay/screens/post/post_state.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:bluejay/screens/post/reddit_post.dart';
import 'package:go_router/go_router.dart';

class RedditFeedWidget extends StatefulWidget {
  @override
  RedditFeedWidgetState createState() => RedditFeedWidgetState();
}

class RedditFeedWidgetState extends State<RedditFeedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var feedState = Provider.of<FeedState>(context, listen: false);
      if (feedState.data.isEmpty) {
        feedState.fetchBest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var feedState = context.watch<FeedState>();
    var postState = context.watch<PostState>();
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: Stack(children: [
        RefreshIndicator(
          onRefresh: feedState.fetchBest,
          child: ListView.builder(
              itemCount: feedState.data.length,
              itemBuilder: (itemContext, index) {
                Post post = feedState.data[index];
                return GestureDetector(
                  onTap: () {
                    postState.setCurrent(post);
                    context.push('/post');
                  },
                  child: RedditPostView(
                    post: post,
                    isExpanded: false,
                    vote: feedState.vote,
                  ),
                );
              }),
        ),
        if (feedState.isLoading) Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}
