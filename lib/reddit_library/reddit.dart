import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'subreddit.dart';
import 'listing.dart';
import 'query.dart';
import 'reddit_user.dart';
import 'multireddit.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class Reddit {
  static final Uri _baseApiUriPublic = Uri.parse("http://www.reddit.com/");
  static final Uri _baseApiUriOauth = Uri.parse("https://oauth.reddit.com/");

  static final Uri _authEdp =
      Uri.parse("https://www.reddit.com/api/v1/authorize");
  static final Uri _tokenEdp =
      Uri.parse("https://www.reddit.com/api/v1/access_token");

  static final Logger logger = Logger("reddit");

  http.Client client;
  late Subreddit _front;

  Reddit(this.client) : _oauthEnabled = false {
    _front = Subreddit(this, null);
  }

  Subreddit get frontPage => _front;

  Subreddit sub(String? sub) => Subreddit(this, sub);

  RedditUser user(String username) => RedditUser(this, username);

  ///  FilterableQuery multi(String multiPath) => new FilterableQuery._(this, "api/multi/$multiPath", {}, ["expand_srs"]);
  Multireddit multi(String user, String multiName) =>
      Multireddit(this, user, multiName);

  Future<bool> vote(String id, VoteDir dir) async {
    if (!_oauthEnabled) return false;
    Uri uri = baseApiUri().replace(
        path: 'api/vote',
        queryParameters: {"dir": "${getVoteDir(dir)}", "id": id});
    print("$id, $dir, $uri");
    var headers = {
      'Content-type': 'application/x-www-form-urlencoded;charset=UTF-8',
      'Accept': 'application/x-www-form-urlencoded;charset=UTF-8'
    };
    var result = await client.post(uri, headers: headers);
    return result.statusCode == 200;
  }
  /* BROWSE SUBREDDITS */

  /// Allowed filters are all Listing filters.
  Listing newSubreddits() => Listing(this, "subreddits/new", {});

  /// Allowed filters are all Listing filters.
  Listing popularSubreddits() => Listing(this, "subreddits/popular", {});

  /// Allowed filters are "omit".
  FilterableQuery recommendedSubreddits(Iterable<String> subs) =>
      FilterableQuery(this, "api/recommend/sr/${subs.join(",")}", {}, ["omit"]);

  /// Allowed filters are all Listing filters.
  Listing searchSubreddits(String query) =>
      Listing(this, "subreddits/search", {"q": query});

  Query subredditsByTopic(String topic) =>
      Query(this, "api/subreddits_by_topic", {"query": topic});

  /// Allowed filters are "id", "limit", "url".
  FilterableQuery info() =>
      FilterableQuery(this, "api/info", {}, ["id", "limit", "url"]);

  /* AUTHENTICATION */

  Uri baseApiUri() => _oauthEnabled ? _baseApiUriOauth : _baseApiUriPublic;

  bool _oauthEnabled;
  oauth2.AuthorizationCodeGrant? _grant;

  /// Start the OAuth2 setup.
  ///
  /// After calling this method, directly call [authFinish] for App-only auth or use the [authUrl] to get
  /// authorization information from the user and provide those to [authFinish].
  void authSetup(String identifier, String secret) {
    if (_grant != null) {
      return;
    }
    if (_oauthEnabled) {
      throw StateError("OAuth2 is already enabled");
    }
    _grant = oauth2.AuthorizationCodeGrant(identifier, _authEdp, _tokenEdp,
        secret: secret, httpClient: client);
  }

  /// Get the authorization URL to forward a user to to get auth information.
  Uri authUrl(redirectUrl,
      {required List<String> scopes, required String state}) {
    if (_grant == null) throw StateError("Should first call setupOAuth2");
    if (_oauthEnabled) throw StateError("OAuth2 is already enabled");
    if (redirectUrl is String) {
      redirectUrl = Uri.parse(redirectUrl);
    } else if (redirectUrl is! Uri) {
      throw ArgumentError(
          "redirectUrl parameter must be either of type Uri or String");
    }
    return _grant!
        .getAuthorizationUrl(redirectUrl, scopes: scopes, state: state);
  }

  /// Finish the OAuth2 setup.
  /// There are several options:
  ///
  /// - App-only auth
  ///   Use either no parameters or provide [username] and [password]. Note that not passing user information will
  ///   often result in getting 503 errors. E.g.
  ///
  ///     await reddit.authFinish(username: "sroose", password: "you wish");
  ///     // or
  ///     await reddit.authFinish();
  ///
  /// - User auth
  ///   Provide either [response] or [code], depending on what you received from the authorization server.
  ///   In most cases, the response from the server contains the code, but you can also just provide the complete
  ///   response. E.g.
  ///
  ///     await reddit.authFinish(code: "code_from_server");
  ///     // or
  ///     await reddit.authFinish(response: authServerResponse);
  ///
  /// The Reddit instance provided by the Future, is the same as the instance this method is invoked on.
  Future<Reddit> authFinish(
      {Map<String, String>? response,
      String? code,
      String? username,
      String? password}) async {
    if (_grant == null) throw StateError("Should first call setupOAuth2");
    if (_oauthEnabled) throw StateError("OAuth2 is already enabled");

    Reddit withAuthClient(oauth2.Client oauthClient) {
      logger.info("OAuth2 setup successful.");
      client = oauthClient;
      _oauthEnabled = true;
      _grant = null;
      return this;
    }

    // USER-ENABLED AUTH
    //  (flow using AuthorizationCodeGrant from oauth2 package)
    logger.info("Enabling user authentication.");
    if (response != null && code == null) {
      return withAuthClient(
          await _grant!.handleAuthorizationResponse(response));
    } else if (code != null && response == null) {
      return withAuthClient(await _grant!.handleAuthorizationCode(code));
    } else {
      throw ArgumentError(
          "Only either of response and code should be provided.");
    }
  }

  Reddit relogin(oauth2.Credentials credentials, String identifier) {
    client = oauth2.Client(credentials, identifier: identifier);
    _oauthEnabled = true;
    return this;
  }
}

enum VoteDir { down, neutral, up }

int getVoteDir(VoteDir dir) {
  switch (dir) {
    case VoteDir.down:
      return -1;
    case VoteDir.up:
      return 1;
    case VoteDir.neutral:
    default:
      return 0;
  }
}
