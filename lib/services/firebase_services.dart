// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/admin/screens/dashboard.dart';
import 'package:recipe_app/authentication/login.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/screens.dart';

class AuthFunctions {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<User?> get getAuthChange => _auth
      .authStateChanges(); //so that if user login then exit app he stays login next time

//Login Function
  static Future<UserCredential?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user!.emailVerified) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text(
        //       "login Success",
        //       style: TextStyle(color: Color.fromARGB(255, 235, 236, 240)),
        //     ),
        //   ),
        // );
        var data = await _firestore
            .collection('users')
            .where('uid', isEqualTo: _auth.currentUser!.uid)
            .get();

        if (data.docs[0]["isAdmin"] == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Screens()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Email not verified,please verify your email",
              style: TextStyle(color: Color.fromARGB(255, 235, 236, 240)),
            ),
          ),
        );
      }
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      return null;
    }
  }
  // Signup Function

  static Future<UserCredential?> signUp(String name, String Email,
      String password, BuildContext context //take these values from user by ui
      ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: Email, password: password); //create user

      await userCredential.user!
          .sendEmailVerification(); //user would not be null as registered above,sending email for verification

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid, //when user us created given a unique id
        name: name,
        email: Email,
        pp: "",
        isAdmin: false,
        createdOn: DateTime.now(),
      );

      _firestore
          .collection(
              "users") //make a collection named users if already exists just go there
          .doc(userCredential.user!.uid) //assign a uniue id to document
          .set(userModel.toJson()); //save data of usermodel in map type

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Verification email sent,please check your mail inbox",
            style: TextStyle(color: Color.fromARGB(255, 235, 236, 240)),
          ),
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));

      return userCredential; //if bool return true
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error:$e "),
      ));

      return null;
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Recovery email sent to $email",
            style: const TextStyle(color: Color.fromARGB(255, 235, 236, 240)),
          ),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }).onError((Error, StackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$Error"),
      ));
    });
  }

  static Future<void> logout(BuildContext context) async {
    await _auth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}
