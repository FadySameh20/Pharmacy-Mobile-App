class ItemModel {
  String? description;
  String? name;
  String? image;
  String? itemid;
  ItemModel(this.description, this.name, this.image, this.itemid);

  ItemModel.fromJson(Map<String, dynamic> json) {
    description = json["description"] as String;
    name = json["name"] as String;
    image = json["image"] as String;
    itemid = json["itemid"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "image": image,
      "itemid": itemid
    };
  }
}
