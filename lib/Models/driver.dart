import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    this.id,
    this.username,
    this.modelo,
    this.placa,
    this.email,
    this.password,
  });

  String id;
  String username;
  String modelo;
  String placa;
  String email;
  String password;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        username: json["username"],
        modelo: json["modelo"],
        placa: json["placa"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "modelo": modelo,
        "placa": placa,
        "email": email,
        "password": password,
      };
}
