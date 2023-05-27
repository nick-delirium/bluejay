import 'listings.dart';
import 'reddit.dart';
import 'query.dart';

class Multireddit extends Listings {
  final Reddit _reddit;

  final String user;
  final String name;

  Multireddit(this._reddit, this.user, this.name) : super(_reddit);

  @override
  String get path => "user/$user/m/$name";

  FilterableQuery info() =>
      FilterableQuery(_reddit, "api/multi/$path", {}, ["expand_srs"]);

  FilterableQuery description() =>
      FilterableQuery(_reddit, "api/multi/$path/description", {});
}
