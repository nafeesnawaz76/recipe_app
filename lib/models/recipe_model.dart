class RecipeModel {
  late String id;
  late String name;
  late bool recipeOfWeek;
  late String image;
  late String description;
  late String difficulty;
  late List ingredients;
  late String calories;
  late String serving;
  late String prep;
  late String cook;
  late String category;
  late String categoryId;
  late bool isFavourite;
  late String link;

  RecipeModel(
      {required this.id,
      required this.name,
      required this.recipeOfWeek,
      required this.image,
      required this.description,
      required this.difficulty,
      required this.ingredients,
      required this.calories,
      required this.serving,
      required this.prep,
      required this.cook,
      required this.category,
      required this.categoryId,
      required this.isFavourite,
      required this.link});

  RecipeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    recipeOfWeek = json['recipeOfWeek'];
    image = json['image'];
    description = json['description'];
    difficulty = json['difficulty'];
    ingredients = json['ingredients'].cast<String>();
    calories = json['calories'];
    serving = json['serving'];
    prep = json['prep'];
    cook = json['cook'];
    link = json['link'];
    category = json['category'];
    categoryId = json["categoryId"];
    isFavourite = json['isFavourite'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['recipeOfWeek'] = this.recipeOfWeek;
    data['image'] = this.image;
    data['description'] = this.description;
    data['difficulty'] = this.difficulty;
    data['ingredients'] = this.ingredients;
    data['calories'] = this.calories;
    data['serving'] = this.serving;
    data['prep'] = this.prep;
    data['cook'] = this.cook;
    data['link'] = this.link;
    data['category'] = this.category;
    data["categoryId"] = this.categoryId;
    data['isFavourite'] = this.isFavourite;
    return data;
  }
}
