// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/admin/screens/add_recipe.dart';
import 'package:recipe_app/admin/screens/categories.dart';
import 'package:recipe_app/admin/screens/dashboard.dart';
import 'package:recipe_app/authentication/login.dart';
import 'package:recipe_app/firebase_options.dart';
import 'package:recipe_app/practice.dart';
import 'package:recipe_app/screens.dart';
import 'package:recipe_app/screens/home_page.dart';
import 'package:recipe_app/screens/recipe_details.dart';
import 'package:recipe_app/screens/bookmarks.dart';
import 'package:recipe_app/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const Ecommerce());
  } catch (e) {
    // ignore: avoid_print
    print('Error: $e');
  }
  // runApp(const Ecommerce());
}

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: Dashboard(),
    );
  }
}
