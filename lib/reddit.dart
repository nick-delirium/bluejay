import 'reddit_library/reddit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'types/reddit_post.dart';

class RedditAPI {
  /// by default we start with userless client, but on a first request
  /// we check if user is logged in and then swap client to oauth2 if yes
  Reddit _reddit = Reddit(Client());
  bool isAuth = false;
  RedditAPI();

  /// this looks really dumb but I have no time to refactor
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

  Future<List<Post>> getHot(int limit, int seen) async {
    await checkAuth();
    //
    List<Post> posts = [];
    var result = await _reddit.frontPage.hot().limit(limit).count(seen).fetch();
    for (var post in result['data']['children']) {
      posts.add(Post.fromJson(post['data']));
    }
    return posts;
  }

  // List<dynamic>
  Future<void> fetchComments(String sub, String postId) async {
    var comments =
        await _reddit.sub(sub).comments(postId).filter('depth', 3).fetch();

    /// TODO: map this maddness, create comment class
    print(comments);
    // return comments['data']
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
