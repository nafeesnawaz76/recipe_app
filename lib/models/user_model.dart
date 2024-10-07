class UserModel {
  late String uid;
  late String name;
  late String email;
  late bool isAdmin;
  late String pp;
  late dynamic createdOn;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.isAdmin,
      required this.pp,
      required this.createdOn});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    name = json['name'];
    email = json['email'];
    isAdmin = json['isAdmin'];
    pp = json['pp'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uid"] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isAdmin'] = this.isAdmin;
    data["pp"] = this.pp;
    data["createdOn"] = this.createdOn;
    return data;
  }
}
