import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipe_details.dart';

class RecipeOfWeek extends StatelessWidget {
  const RecipeOfWeek({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('recipe')
          .where('recipeOfWeek', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              height: 130,
              child: SpinKitFadingCube(
                color: Color(0xff68D0D6),
                size: 30,
              ),
            ),
          );
        }
        if (snapshot.data != null) {
          final productData = snapshot.data!.docs[0];
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
              elevation: 4,
              child: Container(
                // height: 140,
                width: MediaQuery.of(context).size.width,
                //margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          snapshot.data!.docs[0]["image"],
                          height: 130,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              snapshot.data!.docs[0]["name"],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyan),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.fire,
                                size: 20,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data!.docs[0]["calories"],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.stopwatch,
                                size: 20,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data!.docs[0]["cook"],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.speed,
                                size: 22,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data!.docs[0]["difficulty"],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
