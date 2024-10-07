import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_app/authentication/login.dart';
import 'package:recipe_app/practice.dart';
import 'package:recipe_app/screens.dart';
import 'package:recipe_app/services/firebase_services.dart';
import 'package:recipe_app/widgets/textformfield.dart';

class Signup extends StatefulWidget {
  Signup({
    super.key,
  });

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmpasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: .75,
            colors: [Color.fromARGB(255, 194, 245, 245), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  "assets/logo.png",
                  height: 150,
                ),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your details",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _nameController,
                        hinttxt: "Name",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _emailController,
                        hinttxt: "Email",
                        validation: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        hinttxt: 'Password',
                        suffixIcon: Icons.remove_red_eye_outlined,
                        validation: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'Please enter a password with at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _confirmpasswordController,
                        hinttxt: 'Confirm Password',
                        suffixIcon: Icons.remove_red_eye_outlined,
                        validation: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'Please enter a password with at least 8 characters';
                          }
                          if (value != _passwordController.text) {
                            return "password do not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: const WidgetStatePropertyAll(
                        Color(0xff68D0D6),
                      ),
                      minimumSize: const WidgetStatePropertyAll(
                          Size(double.infinity, 50))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      AuthFunctions.signUp(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          context);

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Center(
                            child: SpinKitFadingCube(
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Animal.cat("nafees");
                        Animal.dog();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: const Text(
                        "Sign in",
                        style:
                            TextStyle(color: Color(0xff68D0D6), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
