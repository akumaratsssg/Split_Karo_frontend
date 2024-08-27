class User {
  final String userName;
  final String userEmail;
  final String userPassword;
  final double userBalance;

  User({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userBalance,
  });

  // Convert a User object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_email': userEmail,
      'user_password': userPassword,
      'user_balance': userBalance,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userPassword: json['user_password'] ?? '',
      userBalance: (json['user_balance'] != null)
          ? double.tryParse(json['user_balance'].toString()) ?? 0.0
          : 0.0,
    );
  }
}





