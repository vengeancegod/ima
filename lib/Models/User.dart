import 'dart:convert';
User userJson(String str) =>
    User.fromJson(jsonDecode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String name;
  String email;
  String password;
  int numberPhone;
  bool active;
  List roles;

  User({required this.name, required this.id, required this.email, required this.password, required this.numberPhone, required this.active, required this.roles});
  factory User.fromJson(Map<String, dynamic> json) => User(

      id: json["id"],
    name: json["name"],
    email: json["email"],
      password: json["password"],
      numberPhone: json["numberPhone"],
    active: json["active"],
    roles: json["roles"]
  );

  Map<String, dynamic> toJson() => {
    "name":name,
    "email": email,
    "email": password,
    'id':id,
    "numberPhone": numberPhone,
    "active": active,
    "roles": roles
  };
}