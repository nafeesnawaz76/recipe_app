import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/admin/screens/dashboard.dart';
import '../screens.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/two.json", height: 150),
                  const Text(
                    "Sizzle",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ],
              )
            : Container(), // Empty container since navigation happens when loading completes
      ),
    );
  }

  Future<void> checkUser() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      var data = await _firestore
          .collection('users')
          .where('uid', isEqualTo: _auth.currentUser?.uid)
          .get();

      bool isAdmin = data.docs[0]["isAdmin"] == true;

      // Safely navigate after the async operation completes and if the widget is still mounted
      if (mounted) {
        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Screens()),
          );
        }
      }
    } catch (e) {
      // Handle potential errors
      print('Error checking user: $e');
    } finally {
      // Ensure _isLoading is set to false after the check completes
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
