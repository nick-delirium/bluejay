import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/reddit.dart';
import 'package:bluejay/types/reddit_post.dart';

class FeedState extends ChangeNotifier {
  List<Post> data = [];
  final RedditAPI _api = redditApi;
  bool isLoading = false;

  Future<void> fetchBest() async {
    data = await _api.getHot(30, 0);
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
