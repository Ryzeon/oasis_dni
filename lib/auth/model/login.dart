class Login {
  String username;
  String password;

  Login({
    required this.username,
    required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(username: json['username'], password: json['password']);
  }

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
