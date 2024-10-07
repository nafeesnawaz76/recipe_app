import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipe_details.dart';

class Bookmarks extends StatelessWidget {
  Bookmarks({super.key});
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bookmarks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            currentUser == null
                ? const Center(child: Text("Please login to add bookmarks!"))
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser!.uid)
                        .collection("bookmarks")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No bookmarks found"));
                      }

                      final bookmarks = snapshot.data!.docs;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bookmarks.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final bookmark = bookmarks[index];
                          RecipeModel recipeModel = RecipeModel(
                              categoryId: bookmark["categoryId"],
                              id: bookmark["id"],
                              name: bookmark["name"],
                              recipeOfWeek: bookmark["recipeOfWeek"],
                              image: bookmark["image"],
                              description: bookmark["description"],
                              difficulty: bookmark["difficulty"],
                              ingredients: bookmark["ingredients"],
                              calories: bookmark["calories"],
                              serving: bookmark["serving"],
                              prep: bookmark["prep"],
                              cook: bookmark["cook"],
                              category: bookmark["category"],
                              isFavourite: bookmark["isFavourite"],
                              link: bookmark["link"]);
                          return GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  RecipeDetails(recipeModel: recipeModel));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                margin: const EdgeInsets.all(0),
                                child: ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(recipeModel.image)),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        recipeModel.name,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text(
                                        recipeModel.category,
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.cyan),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _firestore
                                            .collection('users')
                                            .doc(currentUser!.uid)
                                            .collection('bookmarks')
                                            .doc(bookmark.id)
                                            .delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
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
