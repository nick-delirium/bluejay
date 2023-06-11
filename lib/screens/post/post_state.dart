import 'package:bluejay/reddit_library/reddit.dart';
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
    isLoading = false;
    notifyListeners();
  }

  Future<void> vote(VoteDir dir) async {
    var result = await currentPost!.vote(dir);
    if (result == true) {
      currentPost!.upvoteDir = dir;
    }
    notifyListeners();
  }

  Future<void> commentVote(Comment comment, VoteDir dir) async {
    var result = await comment.vote(dir);
    if (result == true) {
      var changeIndex =
          comments.indexWhere((element) => element.id == comment.id);
      comments[changeIndex] = comment;
    }
    notifyListeners();
  }
}
