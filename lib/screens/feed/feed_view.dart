import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feed_state.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:bluejay/utils/time.dart';

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
    print(feedState.data.length);
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: Stack(children: [
        RefreshIndicator(
          onRefresh: feedState.fetchBest,
          child: ListView.builder(
              itemCount: feedState.data.length,
              itemBuilder: (context, index) {
                Post post = feedState.data[index];
                return RedditPostView(
                  post: post,
                );
              }),
        ),
        if (feedState.isLoading) Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}

class RedditPostView extends StatelessWidget {
  final Post post;
  const RedditPostView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColorDark,
      padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "in ",
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
              Text(post.subreddit),
              SizedBox(width: 4),
              Spacer(),
              Text(
                fullDateFromMs(post.createdAt),
                style: TextStyle(fontWeight: FontWeight.w200),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "by ",
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
              Text(post.author),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Text(post.title, style: TextStyle(fontSize: 16)),
        ],
      )),
    );
  }
}
