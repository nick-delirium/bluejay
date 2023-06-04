import 'reddit_library/reddit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'types/reddit_post.dart';
import 'types/reddit_comment.dart';

/// this looks really dumb but I have no time to refactor
/// submit a PR today!
class RedditAPI {
  /// by default we start with userless client, but on a first request
  /// we check if user is logged in and then swap client to oauth2 if yes
  /// only 10 req per minute allowed for non_auth clients
  Reddit _reddit = Reddit(Client());
  bool isAuth = false;
  String feedSort = 'Hot';
  String commentsSort = 'Hot';
  RedditAPI();

  String setFeedSort(Sort type) {
    feedSort = getSort(type);
    return feedSort;
  }

  String setCommentsSort(Sort type) {
    commentsSort = getSort(type);
    return commentsSort;
  }

  Future<List<Post>> getSubFeed(String sub, int limit, int seen) async {
    await checkAuth();

    List<Post> posts = [];
    var result = await _reddit
        .sub(sub)
        .self(null)
        .filter("sort", feedSort)
        .filter("limit", limit)
        .filter("count", seen)
        .fetch();
    for (var post in result['data']['children']) {
      posts.add(Post.fromJson(post['data']));
    }
    return posts;
  }

  Future<List<Post>> fetchHome(int limit, int seen) async {
    List<Post> result;
    if (feedSort == getSort(Sort.hot)) {
      result = await getHomeHot(30, 0);
    } else {
      result = await getHomeTop(30, 0);
    }

    return result;
  }

  Future<List<Post>> getHomeHot(int limit, int seen) async {
    await checkAuth();

    var result = await _reddit.frontPage.hot().limit(limit).count(seen).fetch();
    return mapPosts(result);
  }

  Future<List<Post>> getHomeTop(int limit, int seen) async {
    await checkAuth();

    var result = await _reddit.frontPage.top().limit(limit).count(seen).fetch();
    return mapPosts(result);
  }

  List<Post> mapPosts(json) {
    List<Post> posts = [];
    for (var post in json['data']['children']) {
      posts.add(Post.fromJson(post['data']));
    }
    return posts;
  }

  // List<dynamic>
  Future<List<Comment>> fetchComments(String sub, String postId) async {
    // .filter('depth', 3)
    var rawComments = await _reddit
        .sub(sub)
        .comments(postId)
        .filter("sort", commentsSort)
        .fetch();
    List<Comment> comments = [];
    for (var commentList in rawComments) {
      for (var comment in commentList['data']['children']) {
        if (comment['kind'] == 't1') {
          var rawComment = comment['data'];
          comments.add(Comment.fromJson(rawComment));
        }
      }
    }

    return comments;
  }

  Future<bool> checkAuth() async {
    // return false;
    if (isAuth) {
      return true;
    }
    var prefs = await SharedPreferences.getInstance();
    String? creds = prefs.getString('oauth_credentials');
    print('credentials: $creds');
    if (creds != null) {
      oauth2.Credentials? credentials = oauth2.Credentials.fromJson(creds);
      print('reddit credentials saved');
      String? apiKey = dotenv.env['API_KEY'];
      if (apiKey == null) {
        throw FormatException("Configure your api key in .env");
      }
      _reddit = _reddit.relogin(credentials, apiKey);
      isAuth = true;
    }
    print('not__authorized');
    return false;
  }

  Uri startAuth() {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw FormatException("Configure your api key in .env");
    }
    _reddit.authSetup(apiKey, "");
    // adding  modconfig, modflair, modlog, modposts, modwiki, 'wikiedit' a bit later
    List<String> scopesArr = [
      'identity',
      'edit',
      'flair',
      'history',
      'mysubreddits',
      'privatemessages',
      'read',
      'report',
      'save',
      'submit',
      'subscribe',
      'vote',
      'wikiread'
    ];
    // do I even need state here
    var authUri = _reddit.authUrl("bluejayapp://unilinks.bluejay.com/login",
        scopes: scopesArr, state: 'lyelinn_login');
    return authUri;
  }

  void authFinish(String code) async {
    var oauthRedditClient = await _reddit.authFinish(code: code);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('oauth_credentials',
        (oauthRedditClient.client as oauth2.Client).credentials.toJson());
    _reddit = oauthRedditClient;
  }
}

RedditAPI redditApi = RedditAPI();

enum Sort { hot, top, fresh, controversial }

String getSort(Sort sortType) {
  switch (sortType) {
    case Sort.top:
      return 'Top';
    case Sort.fresh:
      return 'New';
    case Sort.controversial:
      return 'Controversial';
    case Sort.hot:
    default:
      return 'Hot';
  }
}
