import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/authentication/login.dart';
import 'package:recipe_app/screens/edit_profile.dart';
import 'package:recipe_app/services/firebase_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _name = '';
  String _email = '';
  String _pp = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _name = doc['name'];
        _email = doc['email'];
        _pp = doc['pp'];

        // _nameController.text = _name;
        // _emailController.text = _email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "My Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  user != null
                      ? Get.to(() => EditProfile())
                      : Get.snackbar(
                          "Login Require", "please login to countinue");
                },
                icon: const Icon(Icons.edit_outlined))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: user == null
                        ? const AssetImage("assets/user.png")
                        : NetworkImage(_pp),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null ? "user" : _name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(user == null ? "user.gmail.com" : _email)
                    ],
                  )
                ],
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
            user == null
                ? Container()
                : const ProfileTile(
                    icn: Icons.bookmark_border_rounded,
                    text: 'Bookmarks',
                  ),
            const ProfileTile(
              icn: Icons.dark_mode_outlined,
              text: 'Dark mode',
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Row(
                children: [
                  user != null
                      ? const Icon(
                          Icons.logout_rounded,
                          size: 30,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.logout_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      user != null
                          ? AuthFunctions.logout(context)
                          : Get.to(() => const Login());
                    },
                    child: Text(
                      user != null ? "Logout" : "Login",
                      style: user != null
                          ? const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.red)
                          : const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.black),
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
            color: Colors.cyan,
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
