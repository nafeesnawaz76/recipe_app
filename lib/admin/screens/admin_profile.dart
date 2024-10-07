import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/screens/edit_profile.dart';
import 'package:recipe_app/services/firebase_services.dart';

class AdminProfile extends StatelessWidget {
  AdminProfile({super.key});
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("My Profile"),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditProfile());
                },
                icon: const Icon(Icons.edit_outlined))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    final userDoc = snapshot.data!;
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(userDoc["pp"]),
                          radius: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userDoc["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              userDoc["email"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
            ),
            // const ProfileTile(
            //   icn: Icons.bookmark_border_rounded,
            //   text: 'Bookmarks',
            // ),
            const ProfileTile(
              icn: Icons.dark_mode_outlined,
              text: 'Dark mode',
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthFunctions.logout(context);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.text,
    required this.icn,
  });
  final String text;
  final IconData icn;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Row(
        children: [
          Icon(
            icn,
            size: 30,
            color: const Color(0xff68D0D6),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          )
        ],
      ),
    );
  }
}
