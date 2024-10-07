class CategoryModel {
  late String id;
  late String name;
  late String image;

  late dynamic createdOn;

  CategoryModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.createdOn});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json['name'];
    image = json['image'];

    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;

    data["createdOn"] = this.createdOn;
    return data;
  }
}
