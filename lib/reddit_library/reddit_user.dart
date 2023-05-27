import 'reddit.dart';
import 'query.dart';
import 'listing.dart';
import 'multireddit.dart';

/// Keep in mind that most users hide certain information from their public profile. This information is not
/// accessible through the API either.
class RedditUser {
  final Reddit _reddit;

  final String name;

  RedditUser(this._reddit, this.name);

  String _res(String res) => "user/$name/$res";

  /* ABOUT */

  Query about() => Query(_reddit, _res("about"), {});

  /* CONTENT */

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing overview([String? t]) {
    Listing listing = Listing(_reddit, _res("overview"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing submitted([String? t]) {
    Listing listing = Listing(_reddit, _res("submitted"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing comments([String? t]) {
    Listing listing = Listing(_reddit, _res("comments"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing liked([String? t]) {
    Listing listing = Listing(_reddit, _res("liked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing disliked([String? t]) {
    Listing listing = Listing(_reddit, _res("disliked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing hidden([String? t]) {
    Listing listing = Listing(_reddit, _res("hidden"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing saved([String? t]) {
    Listing listing = Listing(_reddit, _res("saved"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /// The parameter [t] is equivalent to using the "t" filter.
  /// Allowed filters are "sort", "t" and all Listing filters.
  Listing gilded([String? t]) {
    Listing listing = Listing(_reddit, _res("gilded"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) as Listing : listing;
  }

  /* MULTIS */

  /// Allowed filters are "expand_srs".
  FilterableQuery multis() =>
      FilterableQuery(_reddit, "api/multi/user/$name", {}, ["expand_srs"]);

  /// A multi curated by this user.
  Multireddit multi(String multiName) => Multireddit(_reddit, name, multiName);

  /* TROPHIES */

  Query trophies() => Query(_reddit, "api/v1/user/$name/trophies", {});
}
