class LoginModel {
  final List roles;
  final int id;

  LoginModel({required this.roles, required this.id});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel (
      roles: json['roles'],
      id: json['id'],
    );
  }
}