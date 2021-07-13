import 'dart:convert';

Client clientFromJson(String str) => Client.fromJson(json.decode(str));

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  Client({
    this.id,
    this.username,
    this.email,
    this.password,
    this.token,
  });

  String id;
  String username;
  String email;
  String password;
  String token;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        // "password": password,
      };
}
