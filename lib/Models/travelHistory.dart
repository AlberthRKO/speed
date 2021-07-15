// To parse this JSON data, do
//
//     final travelHistory = travelHistoryFromJson(jsonString);

import 'dart:convert';

TravelHistory travelHistoryFromJson(String str) =>
    TravelHistory.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistory data) => json.encode(data.toJson());

class TravelHistory {
  TravelHistory({
    this.id,
    this.idClient,
    this.idDriver,
    this.from,
    this.to,
    this.nameDriver,
    this.nameClient,
    this.timestamp,
    this.calificationClient,
    this.calificationDriver,
    this.price,
  });

  String id;
  String idClient;
  String idDriver;
  String from;
  String to;
  String nameDriver;
  String nameClient;
  int timestamp;
  double calificationClient;
  double calificationDriver;
  double price;

  factory TravelHistory.fromJson(Map<String, dynamic> json) => TravelHistory(
        id: json["id"],
        idClient: json["idClient"],
        idDriver: json["idDriver"],
        from: json["from"],
        to: json["to"],
        nameDriver: json["nameDriver"],
        nameClient: json["nameClient"],
        timestamp: json["timestamp"],
        calificationClient: json["calificationClient"]?.toDouble() ?? 0,
        calificationDriver: json["calificationDriver"]?.toDouble() ?? 0,
        price: json["price"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idClient": idClient,
        "idDriver": idDriver,
        "from": from,
        "to": to,
        "nameDriver": nameDriver,
        "nameClient": nameClient,
        "timestamp": timestamp,
        "calificationClient": calificationClient,
        "calificationDriver": calificationDriver,
        "price": price,
      };
}
