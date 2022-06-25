import 'dart:convert';

class ItemPharmacyModel {
  String? item;
  int? price;
  int? quantity;

  ItemPharmacyModel(this.item, this.price, this.quantity);

  ItemPharmacyModel.fromJson(Map<String, dynamic> json) {
    item = json["item"];
    price = json["price"];
    quantity = json["quantity"];
  }
  Map<String, dynamic> toSimpleMap() {
    return {"item": item, "price": price, "quantity": quantity};
  }

  static Map<String, dynamic> toMap(myitem) {
    return {
      "item": myitem.item,
      "price": myitem.price,
      "quantity": myitem.quantity
    };
  }

  static String encode(items) => json.encode(
        items
            .map<Map<String, dynamic>>((item) => ItemPharmacyModel.toMap(item))
            .toList(),
      );

  static List<ItemPharmacyModel> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<ItemPharmacyModel>((item) => ItemPharmacyModel.fromJson(item))
          .toList();
}
