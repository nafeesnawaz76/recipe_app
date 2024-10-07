import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'recipe_details.dart';

class SingleCategory extends StatefulWidget {
  String id;
  SingleCategory({
    super.key,
    required this.id,
  });

  @override
  State<SingleCategory> createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('recipe')
                  .where("categoryId", isEqualTo: widget.id)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No recipe found"));
                }

                final recipes = snapshot.data!.docs;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recipes.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    RecipeModel recipeModel = RecipeModel(
                        categoryId: recipe["categoryId"],
                        id: recipe["id"],
                        name: recipe["name"],
                        recipeOfWeek: recipe["recipeOfWeek"],
                        image: recipe["image"],
                        description: recipe["description"],
                        difficulty: recipe["difficulty"],
                        ingredients: recipe["ingredients"],
                        calories: recipe["calories"],
                        serving: recipe["serving"],
                        prep: recipe["prep"],
                        cook: recipe["cook"],
                        category: recipe["category"],
                        isFavourite: recipe["isFavourite"],
                        link: recipe["link"]);
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => RecipeDetails(recipeModel: recipeModel));
                      },
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            child: ListTile(
                              leading: Image.network(recipeModel.image),
                              title: Text(recipeModel.name),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
