import 'dart:collection';

import 'query.dart';
import 'dart:async';
import 'reddit.dart';
import 'fullname.dart';

/// The filters included in a Listing are "after", "before", "count", "limit", "show".
class Listing extends FilterableQuery implements Stream<ListingResult> {
  static const List<String> _listingFilters = [
    "after",
    "before",
    "count",
    "limit",
    "show"
  ];

  late StreamController<ListingResult> _controller;

  Listing(Reddit reddit, String resource, Map params,
      [Iterable<String> extraFilters = const []])
      : super(reddit, resource, params, [..._listingFilters, ...extraFilters]) {
    _controller = StreamController(onListen: fetch);
  }

  Listing after(fullname) {
    if (params.containsKey("before")) {
      throw StateError(
          "It is not possible to specify both the after and before filter.");
    }
    fullname = Fullname.cast(fullname);
    params["after"] = fullname;
    return this;
  }

  Listing before(fullname) {
    if (params.containsKey("after")) {
      throw StateError(
          "It is not possible to specify both the after and before filter.");
    }
    fullname = Fullname.cast(fullname);
    params["before"] = fullname;
    return this;
  }

  Listing count([int count = 0]) {
    params["count"] = count;
    return this;
  }

  Listing limit([int limit = 25]) {
    params["limit"] = limit;
    return this;
  }

  Listing show() {
    params["show"] = "all";
    return this;
  }

  /// The stream to which results are added when calling [fetch].
  Stream<ListingResult> get results => _controller.stream;

  @override
  Future<ListingResult> fetch() {
    return super.fetch().then((Map<String, dynamic> result) {
      if (result.containsKey("data")) {
        params["after"] = result["data"]["after"];
        params["before"] = result["data"]["before"];
      }
      ListingResult res = ListingResult(result, this);
      _controller.add(res);
      return res;
    });
  }
}

/// This class is a Map containing data on a Listing stream.
/// You can use it just like the result of [Query.fetch].
/// The method [fetchMore] allows to request the next batch of data.
class ListingResult extends MapMixin<String, dynamic> {
  final Map<String, dynamic> _result;
  final Listing _listing;

  ListingResult(this._result, this._listing);

  Future<ListingResult> fetchMore() => _listing.fetch();

  @override
  operator [](Object? key) => _result[key];

  @override
  operator []=(String key, dynamic value) => _result[key] = value;

  @override
  Iterable<String> get keys => _result.keys;

  @override
  dynamic remove(Object? key) => _result.remove(key);

  @override
  void clear() => _result.clear();

  @override
  String toString() => _result.toString();
}
