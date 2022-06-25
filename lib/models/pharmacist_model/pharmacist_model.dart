class PharmacistModel {
  String? name;
  String? email;
  String? pharmacyId;
  String? pharmacistId;
  String? phone;

  PharmacistModel(
      this.name, this.email, this.pharmacyId, this.pharmacistId, this.phone);

  PharmacistModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    pharmacyId = json["pharmacyId"];
    pharmacistId = json["pharmacistId"];
    phone = json["phone"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "pharmacyId": pharmacyId,
      "pharmacistId": pharmacistId,
      "phone": phone
    };
  }
}
