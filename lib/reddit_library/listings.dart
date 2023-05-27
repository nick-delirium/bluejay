import 'reddit.dart';
import 'listing.dart';

class Listings {
  final Reddit _reddit;

  String? get path => null;

  String _res(String res) => path == null ? res : "$path/$res";

  Listings(this._reddit);

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "t" and all Listing filters.
  Listing controversial([String? t]) {
    Listing listing = Listing(_reddit, _res("controversial"), {}, ["t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// Returns "hot" posts
  ///
  /// Allowed filters are all Listing filters.
  Listing hot() => Listing(_reddit, _res("hot"), {});

  /// Allowed filters are all Listing filters.
  Listing newPosts() => Listing(_reddit, _res("new"), {});

  /// Get the top posts for this subreddit.
  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "t" and all Listing filters.
  Listing top([String? t]) {
    Listing listing = Listing(_reddit, _res("top"), {}, ["t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }
}
