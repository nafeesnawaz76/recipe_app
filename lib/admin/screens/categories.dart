import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:recipe_app/admin/screens/add_category.dart';
import 'package:recipe_app/admin/screens/add_recipe.dart';
import 'package:recipe_app/models/category_model.dart';
import 'package:recipe_app/models/recipe_model.dart';

class AdminCategories extends StatelessWidget {
  const AdminCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('categories')
              // .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error occurred while fetching Categories!');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            if (snapshot.hasData) {
              return Text(
                  'Categories (${snapshot.data!.docs.length.toString()})');
            }
            return Container();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => AddCategory());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            // .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred while fetching category!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCube(
                color: Color(0xff68D0D6),
                size: 30,
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No category found!'),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                CategoryModel categoryModel = CategoryModel(
                    id: productData["id"],
                    name: productData["name"],
                    image: productData["image"],
                    createdOn: productData["createdOn"]);
                return Card(
                  elevation: 2,
                  color: Colors.white,
                  child: ListTile(
                    leading: categoryModel.image.isEmpty
                        ? CircleAvatar(
                            child: Image.asset(
                            "assets/recipeLogo.png",
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                          ))
                        : CircleAvatar(
                            child: Image.network(
                              categoryModel.image,
                              height: 100,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                    title: Text(categoryModel.name),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit)),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
