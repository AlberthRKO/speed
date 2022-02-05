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
    this.token,
    this.image,
    this.imageModelo,
    this.imagePlaca,
    this.imageLicencia,
    this.estado,
  });

  String id;
  String username;
  String modelo;
  String placa;
  String email;
  String password;
  String token;
  String image;
  String imageModelo;
  String imagePlaca;
  String imageLicencia;
  String estado;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        username: json["username"],
        modelo: json["modelo"],
        placa: json["placa"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
        image: json["image"],
        imageModelo: json["imageModelo"],
        imagePlaca: json["imagePlaca"],
        imageLicencia: json["imageLicencia"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "modelo": modelo,
        "placa": placa,
        "email": email,
        "token": token,
        "image": image,
        "imageModelo": imageModelo,
        "imagePlaca": imagePlaca,
        "imageLicencia": imageLicencia,
        "estado": estado,
        // "password": password,
      };
}
