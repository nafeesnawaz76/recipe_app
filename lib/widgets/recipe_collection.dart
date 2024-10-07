import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipe_details.dart';

class RecipeCollection extends StatelessWidget {
  const RecipeCollection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              height: 250,
              child: const SpinKitFadingCube(
                color: Colors.cyan,
                size: 30,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Center(
                  child: Text(
                "No recipes availables!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.cyan),
              )),
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
                padding: const EdgeInsets.all(0),
                primary: false, //smooth scroll
                shrinkWrap: true, //unbounded height
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 0.8),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  RecipeModel recipeModel = RecipeModel(
                    categoryId: productData["categoryId"],
                    link: productData["link"],
                    name: productData['name'],
                    image: productData['image'],
                    description: productData['description'],
                    isFavourite: productData['isFavourite'],
                    recipeOfWeek: productData['recipeOfWeek'],
                    difficulty: productData['difficulty'],
                    ingredients: productData['ingredients'],
                    calories: productData['calories'],
                    serving: productData['serving'],
                    prep: productData['prep'],
                    cook: productData['cook'],
                    category: productData['category'],
                    id: productData['cook'],
                  );
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeDetails(
                                    recipeModel: recipeModel,
                                  )));
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.cyan.withOpacity(0.01)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      recipeModel.image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                recipeModel.category,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                recipeModel.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return Container();
        });
  }
}
