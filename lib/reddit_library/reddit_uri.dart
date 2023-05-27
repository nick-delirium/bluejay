class RedditUri {
  final Uri uri;

  // from subreddit.py reddit code
  static final RegExp _regexSub = RegExp(r"[A-Za-z0-9][A-Za-z0-9_]{2,20}");

  static final RegExp _regexpUrlPost = RegExp(r"^\/r\/(" +
      _regexSub.pattern +
      r")(?:\/(?:comments\/([a-z0-9]+)\/[^\/]+)(?:\/([a-z0-9]+)?(?:\/)?)?)?$");

  static final RegExp _regexpUrlUser = RegExp(
      r"^\/user\/([^\/]+)(?:\/(?:(comments|submitted|gilded)(?:\/)?)?)?$");

  factory RedditUri(dynamic /*String|Uri*/ uri) {
    if (uri is Uri) {
      return RedditUri._internal(uri);
    } else if (uri is String) {
      return RedditUri._internal(Uri.parse(uri));
    } else {
      throw ArgumentError("uri parameter must be of type Uri or String");
    }
  }

  RedditUri._internal(this.uri) {
    if (!matches(uri)) {
      throw ArgumentError("Invalid Reddit URI: $uri");
    }
  }

  /* SUB */

  String? get subReddit => _regexpUrlPost.firstMatch(uri.path)?.group(1);

  String? get postId => _regexpUrlPost.firstMatch(uri.path)?.group(2);

  String? get commentId => _regexpUrlPost.firstMatch(uri.path)?.group(3);

  /* USERS */

  String? get userName => _regexpUrlUser.firstMatch(uri.path)?.group(1);

  /* STATIC */

  static bool matches(Uri uri) {
    var parts = uri.authority.split(".");
    var l = parts.length;
    return l >= 2 && parts[l - 1] == "com" && parts[l - 2] == "reddit";
  }
}
