import 'dart:convert';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) =>
    json.encode(data.toJson());

class ServiceModel {
  String? serviceId;
  String? servicePrice;
  String? serviceName;

  ServiceModel(
      {this.serviceId,
       this.servicePrice,
        this.serviceName,
      });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    servicePrice = json['servicePrice'];
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['servicePrice'] = this.servicePrice;
    data['serviceName'] = this.serviceName;
    return data;
  }
}
