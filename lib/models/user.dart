class User {
  String? id;
  String? tokenJWT;
  String? name;
  String email;
  String password;

  User({
    this.id,
    this.tokenJWT,
    this.name,
    required this.email,
    required this.password,
  });
}
