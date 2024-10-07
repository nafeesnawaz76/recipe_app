import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_app/admin/widgets/search_user.dart';
import 'package:recipe_app/models/user_model.dart';

class AdminUsersScreen extends StatelessWidget {
  AdminUsersScreen({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('isAdmin', isEqualTo: false)
              // .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error occurred while fetching users!');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            if (snapshot.hasData) {
              return Text('Users (${snapshot.data!.docs.length.toString()})');
            }
            return Container();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchUserDelegate(),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isAdmin', isEqualTo: false)
            //.orderBy('createdOn', descending: true)
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
              child: Text('No users found!'),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final datas = snapshot.data!.docs[index];
                UserModel userModel = UserModel(
                  uid: datas['uid'],
                  name: datas['name'],
                  email: datas['email'],
                  pp: datas['pp'],
                  isAdmin: datas['isAdmin'],
                  createdOn: datas['createdOn'],
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        leading: userModel.pp.isEmpty
                            ? const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "assets/user.png",
                                ),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  userModel.pp,
                                ),
                              ),
                        title: Text(userModel.name),
                        trailing: IconButton(
                            onPressed: () async {
                              ;

                              // Get the documents where the 'uid' matches
                              var snapshot = await _firestore
                                  .collection('users')
                                  .where('uid', isEqualTo: userModel.uid)
                                  .get();

                              // Delete each matching document
                              for (var doc in snapshot.docs) {
                                await doc.reference.delete();
                              }

                              User? userToDelete =
                                  FirebaseAuth.instance.currentUser;
                              if (userToDelete != null &&
                                  userToDelete.uid == userModel.uid) {
                                await userToDelete
                                    .delete(); // Deletes the Firebase Auth user
                              }
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
          }

          return Container();
        },
      ),
    );
  }
}
