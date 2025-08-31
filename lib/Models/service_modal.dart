import 'dart:convert';

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  int? id;
  int? saloonId;
  String code;
  String name;
  String icon;
  String description;
  String price;
  int duration;
  int status;
  int? deleteStatus;
  bool? isSelected;
  bool? isExpanded;

  Services({
    this.id,
    this.saloonId,
    required this.code,
    required this.name,
    required this.icon,
    required this.description,
    required this.price,
    required this.duration,
    required this.status,
    this.deleteStatus,
    this.isSelected = false,
    this.isExpanded = false,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json["id"],
        saloonId: json["saloon_id"],
        code: json["code"],
        name: json["name"],
        icon: json["icon"],
        description: json["description"],
        price: json["price"],
        duration: json["duration"],
        status: json["status"],
        deleteStatus: json["delete_status"],
        isSelected: json["isSelected"] ?? false,
        isExpanded: json["isExpanded"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "saloon_id": saloonId,
        "code": code,
        "name": name,
        "icon": icon,
        "description": description,
        "price": price,
        "duration": duration,
        "status": status,
        "delete_status": deleteStatus,
        "isSelected": isSelected,
        "isExpanded": isExpanded,
      };
}
