import 'dart:convert';

class RegisterRequestModel {
//   {
//     "email":"semar@gmail.com",
//     "password":"11111111",
//     "name":"semar"
// }

  final String email;
  final String password;
  final String username;
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'username': username});

    return result;
  }

  factory RegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return RegisterRequestModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromJson(String source) =>
      RegisterRequestModel.fromMap(json.decode(source));
}
