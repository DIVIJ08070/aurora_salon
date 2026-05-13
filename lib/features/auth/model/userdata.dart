class Userdata {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? avatar;

  Userdata({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'avatar': avatar,
    };
  }
}
