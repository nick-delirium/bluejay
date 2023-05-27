class Fullname {
  static final RegExp _regExp = RegExp(r"^t([1-9])\_([0-9a-z]+$)");

  final String _value;

  Fullname(this._value) {
    if (_regExp.hasMatch(_value) == false) {
      throw ArgumentError("The given string $_value is not a valid fullname."
          "See the reddit documentation for more info: https://www.reddit.com/dev/api/oauth#fullnames");
    }
  }

  Fullname.fromId(FullnameType type, String id) : _value = "t${type.index}_$id";

  /// Skip the validity check.
  /// It is not advised to use this constructor.
  const Fullname.constant(this._value);

  factory Fullname.cast(dynamic from) {
    if (from is Fullname) {
      return from;
    } else if (from is String) {
      return Fullname(from);
    }
    throw ArgumentError("Can only cast a fullname from a String.");
  }

  FullnameType get type => FullnameType
      .values[int.parse(_regExp.firstMatch(_value)?.group(1) ?? '0')];

  String get id => _regExp.firstMatch(_value)?.group(2) ?? '000';

  @override
  String toString() => _value;

  @override
  bool operator ==(other) => other is Fullname && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}

enum FullnameType {
  invalid0,
  comment,
  account,
  link,
  message,
  subreddit,
  award,
  invalid7,
  promoCampaign
}
