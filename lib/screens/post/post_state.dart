import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/reddit.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:bluejay/types/reddit_comment.dart';

class PostState extends ChangeNotifier {
  Post? currentPost;
  List<Comment> comments = [];
  final RedditAPI _api = redditApi;
  bool isLoading = false;

  setCurrent(Post post) {
    currentPost = post;
    notifyListeners();
  }

  clear() {
    currentPost = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchComments() async {
    setLoading(true);
    // reddit.sub("dartlang").comments("2ek93l").depth(3).fetch().then(print);
    comments =
        await _api.fetchComments(currentPost!.subredditShort, currentPost!.id);
    print(comments.length);
    isLoading = false;
    notifyListeners();
  }
}
