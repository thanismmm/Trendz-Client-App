// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  bool? success;
  String? message;
  String? token;
  Data? data;

  User({
    this.success,
    this.message,
    this.token,
    this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        success: json["success"],
        message: json["message"],
        token: json["token"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "token": token,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? locationId;
  String? image;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? gender;
  dynamic dob;
  String? phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  Location? location;

  Data({
    this.id,
    this.locationId,
    this.image,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.gender,
    this.dob,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.location,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        locationId: json["location_id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        gender: json["gender"],
        dob: json["dob"],
        phoneNumber: json["phone_number"],
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
        "image": image,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "gender": gender,
        "dob": dob,
        "phone_number": phoneNumber,
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
