// To parse this JSON data, do
//
//     final shopDetails = shopDetailsFromJson(jsonString);

import 'dart:convert';

ShopDetails shopDetailsFromJson(String str) =>
    ShopDetails.fromJson(json.decode(str));

String shopDetailsToJson(ShopDetails data) => json.encode(data.toJson());

class ShopDetails {
  int? id;
  int? locationId;
  String? code;
  String? name;
  String? address;
  String? phoneNumber;
  String? email;
  int? status;
  int? deleteStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Location? location;

  ShopDetails({
    this.id,
    this.locationId,
    this.code,
    this.name,
    this.address,
    this.phoneNumber,
    this.email,
    this.status,
    this.deleteStatus,
    this.createdAt,
    this.updatedAt,
    this.location,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
        id: json["id"],
        locationId: json["location_id"],
        code: json["code"],
        name: json["name"],
        address: json["address"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        status: json["status"],
        deleteStatus: json["delete_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "code": code,
        "name": name,
        "address": address,
        "phone_number": phoneNumber,
        "email": email,
        "status": status,
        "delete_status": deleteStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "location": location?.toJson(),
      };
}

class Location {
  int? id;
  String? name;
  int? status;
  int? deleteStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  Location({
    this.id,
    this.name,
    this.status,
    this.deleteStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        deleteStatus: json["delete_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "delete_status": deleteStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
