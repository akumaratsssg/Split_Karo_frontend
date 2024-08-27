class GroupMember {
  GroupMember({
    required String userEmail,
    required String userName,
  }) : _userEmail = userEmail,
        _userName = userName;

  GroupMember.fromJson(dynamic json)
      : _userEmail = json['user_email'],
        _userName = json['user_name'];

  final String _userEmail;
  final String _userName;

  GroupMember copyWith({
    String? userEmail,
    String? userName,
  }) => GroupMember(
    userEmail: userEmail ?? _userEmail,
    userName: userName ?? _userName,
  );

  String get userEmail => _userEmail;
  String get userName => _userName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_email'] = _userEmail;
    map['user_name'] = _userName;
    return map;
  }
}
