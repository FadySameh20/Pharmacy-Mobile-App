class CustomerModel {
  String? name;
  String? email;
  String? phoneNum;
  String? uid;
  CustomerModel(this.name, this.email, this.phoneNum, this.uid);

  CustomerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    email = json['email'] as String;
    phoneNum = json['phone'] as String;
    uid = json['uid'];
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "phone": phoneNum, "uid": uid};
  }
}
