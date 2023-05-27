import "query.dart";
import "listings.dart";
import "reddit.dart";

class Subreddit extends Listings {
  final Reddit _reddit;

  final String? name;

  String _res(String res) => path == "" ? res : "$path/$res";

  Subreddit(this._reddit, this.name) : super(_reddit);

  @override
  String get path => name == null ? "" : "r/$name";

  Query about() => Query(_reddit, _res("about"), {});

  /// Allowed filters are "comment", "context", "depth", "limit", "sort".
  FilterableQuery comments(String article) => FilterableQuery(
      _reddit,
      _res("comments/$article"),
      {},
      ["comment", "context", "depth", "limit", "sort"]);

  /// Allowed filters are "id", "limit", "url".
  FilterableQuery info() =>
      FilterableQuery(_reddit, _res("api/info"), {}, ["id", "limit", "url"]);

  Query random() => Query(_reddit, _res("random"), {});

  /// Allowed filters are "after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t".
  FilterableQuery search(String query) =>
      FilterableQuery(_reddit, _res("search"), {
        "q": query,
        "restrict_sr": true
      }, [
        "after",
        "before",
        "count",
        "limit",
        "restrict_sr",
        "show",
        "sort",
        "syntax",
        "t"
      ]);

  @override
  String toString() => name == null ? "front page" : "r/$name";
}
