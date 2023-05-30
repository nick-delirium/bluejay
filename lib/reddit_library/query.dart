import 'dart:convert';

import 'package:http/http.dart' as http;
import 'reddit.dart';

class Query {
  final Reddit _reddit;
  String resourse;
  Map params;

  Query(this._reddit, this.resourse, this.params);

  /// Fetch the data from the API. Returns a JSON Map.
  /// Throws a [RedditApiException] of the API returned invalid JSON.
  Future<dynamic> fetch() async {
    Uri uri = _redditUri(resourse, params);
    http.Response response = await _reddit.client.get(uri);
    try {
      print(jsonDecode(response.body).runtimeType);
      return jsonDecode(response.body) as dynamic;
    } on FormatException catch (e) {
      var exc = RedditApiException("Exception in parsing JSON from $uri", e);
      throw exc;
    }
  }

  Uri _redditUri(String resourse, Map params) {
    String path = "$resourse.json";
    var qs = [];
    for (String key in params.keys) {
      String part = Uri.encodeQueryComponent(key);
      var val = params[key];
      if (val != null) {
        part += "=${Uri.encodeQueryComponent(val.toString())}";
      }
      qs.add(part);
    }
    return _reddit.baseApiUri().replace(path: path, query: qs.join("&"));
  }
}

class FilterableQuery extends Query {
  /// The allowed filters
  final Iterable<String> _filters;

  FilterableQuery(Reddit reddit, String resource, Map params,
      [this._filters = const []])
      : super(reddit, resource, params);

  FilterableQuery filter(String filter, [dynamic param]) {
    if (_filters.contains(filter) == false) {
      throw StateError(
          "Filter $filter is not allowed for this query. Allowed filters are $_filters");
    }
    params[filter] = param;
    return this;
  }

  @override
  noSuchMethod(Invocation invocation) {
    if (invocation.isMethod == false) {
      return NoSuchMethodError.withInvocation(this, invocation);
    }
    if (invocation.positionalArguments.length > 1 ||
        invocation.namedArguments.isNotEmpty) {
      throw StateError("Filter methods take zero or one positional arguments.");
    }
    String symbol = invocation.memberName.toString();
    String f = symbol.substring(8, symbol.length - 2);
    return filter(
        f,
        invocation.positionalArguments.isEmpty
            ? null
            : invocation.positionalArguments.first);
  }
}

class RedditApiException implements Exception {
  String? message;
  FormatException? reason;

  RedditApiException([this.message, this.reason]);

  @override
  String toString() => "RedditApiException: $message\n\nReason: $reason";
}
