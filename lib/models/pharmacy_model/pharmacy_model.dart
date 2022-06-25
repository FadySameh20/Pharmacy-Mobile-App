import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';

class PharmacyModel {
  String? name;
  String? address;
  String? phone;
  String? description;
  String? pharmacyid;
  List<ItemPharmacyModel> items = [];
  // List<Pharmacist>
  PharmacyModel(this.name, this.address, this.phone, this.description,
      this.items, this.pharmacyid);

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    // print("lollllllllllllllllllllllllllll");
    name = json["name"] as String;
    address = json["address"] as String;
    phone = json["phone"] as String;
    description = json["description"] as String;
    // items = json["items"];
    // print(map.toList((e) => e.value));
    // print("yayayayaya");
    json['items'].forEach((element) {
      // print(element);
      items.add(ItemPharmacyModel.fromJson(element));
    });
    pharmacyid = json["pharmacyid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "address": address,
      "phone": phone,
      "description": description,
      "pharmacyid": pharmacyid,
      "items": items.map((e) => e.toSimpleMap()).toList()
    };
  }

  Map<String, dynamic> itemstoMap() {
    return {"items": items.map((e) => e.toSimpleMap()).toList()};
  }
}
