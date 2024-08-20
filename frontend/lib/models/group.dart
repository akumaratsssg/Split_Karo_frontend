class Group {
  final String name;
  final String description;
  final String adminName;

  Group({
    required this.name,
    required this.description,
    required this.adminName,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['group_name'] ?? '',
      description: json['group_desc'] ?? '',
      adminName: json['group_admin_name'] ?? '',
    );
  }
}

