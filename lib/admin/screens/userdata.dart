import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/widgets/isadmin.dart';

class Userdata extends StatefulWidget {
  String uid;
  Userdata({super.key, required this.uid});

  @override
  State<Userdata> createState() => _UserdataState();
}

final IsadminCheck isadminController = Get.put(IsadminCheck());

class _UserdataState extends State<Userdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where("uid", isEqualTo: widget.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("error while fetching user details"));
              }

              final recipes = snapshot.data!.docs;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final userdetails = recipes[index];
                  UserModel userModel = UserModel(
                      uid: userdetails["uid"],
                      name: userdetails["name"],
                      email: userdetails["email"],
                      isAdmin: userdetails["isAdmin"],
                      pp: userdetails["pp"],
                      createdOn: userdetails["createdOn"]);
                  return GestureDetector(
                      onTap: () {
                        // Get.to(() => RecipeDetails(recipeModel: recipeModel));
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userModel.pp),
                          ),
                          Text(userModel.name),
                          Text(userModel.email),
                          Obx(() {
                            return Switch(
                              value: isadminController.isadmin.value,
                              onChanged: (value) {
                                // Toggle the admin status when the switch is toggled
                                isadminController.toggleAdmin();
                              },
                            );
                          }),
                          Text(userModel.createdOn.toString())
                        ],
                      ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
