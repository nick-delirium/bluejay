import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/reddit.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:bluejay/reddit_library/reddit.dart';

class FeedState extends ChangeNotifier {
  List<Post> data = [];
  final RedditAPI _api = redditApi;
  bool isLoading = false;

  String get feedSort => _api.feedSort;

  Future<void> fetchBest() async {
    data = await _api.getHomeHot(30, 0);
    notifyListeners();
  }

  Future<void> fetchHome() async {
    data = await _api.fetchHome(30, 0);
    notifyListeners();
  }

  setSort(Sort type) {
    _api.setFeedSort(type);
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> vote(Post post, VoteDir dir) async {
    var result = await post.vote(dir);
    if (result == true) {
      var changeIndex = data.indexWhere((element) => element.id == post.id);
      data[changeIndex] = post;
    }
    notifyListeners();
  }
}
