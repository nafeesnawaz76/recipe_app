// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/authentication/signup.dart';
import 'package:recipe_app/services/firebase_services.dart';
import 'package:recipe_app/widgets/textformfield.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

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
                const SizedBox(height: 60),
                Lottie.asset("assets/two.json", height: 200),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your email and password",
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
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(fontSize: 15),
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
                      AuthFunctions.login(_emailController.text,
                          _passwordController.text, context);
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
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Do not have an account?",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: const Text(
                        "Signup",
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
