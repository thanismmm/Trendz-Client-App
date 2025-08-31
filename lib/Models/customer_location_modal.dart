import 'dart:convert';

CustomerLocation customerLocationFromJson(String str) =>
    CustomerLocation.fromJson(json.decode(str));

String customerLocationToJson(CustomerLocation data) =>
    json.encode(data.toJson());

class CustomerLocation {
  bool? success;
  String? message;
  List<CustomerLocationModal>? data;

  CustomerLocation({
    this.success,
    this.message,
    this.data,
  });

  factory CustomerLocation.fromJson(Map<String, dynamic> json) =>
      CustomerLocation(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CustomerLocationModal>.from(
                json["data"]!.map((x) => CustomerLocationModal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CustomerLocationModal {
  int? id;
  String? name;

  CustomerLocationModal({
    this.id,
    this.name,
  });

  factory CustomerLocationModal.fromJson(Map<String, dynamic> json) =>
      CustomerLocationModal(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
