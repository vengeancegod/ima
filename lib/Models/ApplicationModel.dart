import 'dart:convert';
import 'User.dart';
ApplicationModel applicationJson(String str) =>
    ApplicationModel.fromJson(jsonDecode(str));
String applicationModelToJson(ApplicationModel data) => json.encode(data.toJson());

class ApplicationModel {
  int id;
  String fullName;
  int numberSeriesPassport;
  String insuranceType;
  int insuranceSum;
  String status;
  User user;


  ApplicationModel({required this.id, required this.fullName, required this.numberSeriesPassport, required this.insuranceType, required this.insuranceSum, required this.status, required this.user});
  factory ApplicationModel.fromJson(Map<String, dynamic> json) => ApplicationModel(

      id: json["id"],
      fullName: json["fullName"],
      numberSeriesPassport: json["numberSeriesPassport"],
      insuranceType: json["insuranceType"],
      insuranceSum: json["insuranceSum"],
      status: json["status"],
      user: User.fromJson(json['user']),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "numberSeriesPassport": numberSeriesPassport,
    "insuranceType": insuranceType,
    'insuranceSum':insuranceSum,
    "status": status,
    "user": user.toJson(),

  };
}