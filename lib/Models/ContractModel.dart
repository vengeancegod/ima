import 'dart:convert';
import 'ApplicationModel.dart';
import 'User.dart';
ContractModel contractJson(String str) =>
    ContractModel.fromJson(jsonDecode(str));
String applicationModelToJson(ContractModel data) => json.encode(data.toJson());

class ContractModel {
  int id;
  String fullName;
  String typeTreaty;
  int policySeries;
  int policyNumber;
  String insuranceType;
  double insurancePremium;
  User user_id;
  ApplicationModel application;


  ContractModel({required this.id, required this.fullName, required this.insuranceType, required this.insurancePremium, required this.policyNumber, required this.policySeries,required this.typeTreaty,  required this.user_id, required this.application});
  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(

    id: json["id"],
    fullName: json["fullName"],
    insuranceType: json["insuranceType"],
    typeTreaty: json["typeTreaty"],
    policySeries: json["policySeries"],
    policyNumber: json["policyNumber"],
    insurancePremium: json["insurancePremium"],
    user_id: User.fromJson(json['user_id']),
    application: ApplicationModel.fromJson(json['application'])

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "insuranceType": insuranceType,
    "typeTreaty":typeTreaty,
    "policySeries": policySeries,
    "policyNumber": policyNumber,
    "insurancePremium": insurancePremium,
    "user_id": user_id.toJson(),
    "application": application.toJson(),

  };
}