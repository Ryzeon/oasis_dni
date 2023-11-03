class User {
  String token;
  String id;
  String username;
  List<dynamic> roles;

  User({
    required this.token,
    required this.id,
    required this.username,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        token: json['token'],
        id: json['id'],
        username: json['username'],
        roles: json['roles']);
  }

  bool isReceptionist() {
    return roles.contains("ROLE_RECEPTIONIST") || roles.contains("ROLE_ADMIN");
  }

  bool isAdmin() {
    return roles.contains("ROLE_ADMIN");
  }

  Map<String, dynamic> toJson() =>
      {'token': token, 'id': id, 'username': username, 'roles': roles};
}
