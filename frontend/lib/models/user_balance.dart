/// user_name : "Saksham Negi"
/// balance : -200

class UserBalance {
  UserBalance({
      required String userName,
      required num balance
  }) : _userName = userName,
       _balance = balance;


  UserBalance.fromJson(dynamic json)
    : _userName = json['user_name'],
      _balance = json['balance'];

  final String _userName;
  final num _balance;

  UserBalance copyWith({
    String? userName,
    num? balance,
  }) => UserBalance(  userName: userName ?? _userName,
    balance: balance ?? _balance,
  );

  String get userName => _userName;
  num get balance => _balance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_name'] = _userName;
    map['balance'] = _balance;
    return map;
  }

}