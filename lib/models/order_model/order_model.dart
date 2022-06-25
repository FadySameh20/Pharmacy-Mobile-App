import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';

class OrderModel {
  String? address;
  String? flatNo;
  String? pharmacyId;
  String? customerId;
  String? deliveryDate;
  String? buildNo;
  List<ItemPharmacyModel> items = [];
  String? orderId;

  OrderModel(this.address, this.buildNo, this.flatNo, this.pharmacyId,
      this.customerId, this.deliveryDate, this.items, this.orderId);

  OrderModel.fromJson(Map<String, dynamic> json) {
    address = json["address"];
    flatNo = json["flatNo"];
    pharmacyId = json["pharmacyId"];
    customerId = json["customerId"];
    deliveryDate = json["deliveryDate"];
    buildNo = json["buildNo"];
    orderId = json["orderId"];
    json['items'].forEach((element) {
      items.add(ItemPharmacyModel.fromJson(element));
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "address": address,
      "flatNo": flatNo,
      "pharmacyId": pharmacyId,
      "customerId": customerId,
      "deliveryDate": deliveryDate,
      "buildNo": buildNo,
      "orderId": orderId,
      "items": items.map((e) => e.toSimpleMap()).toList()
    };
  }
}
