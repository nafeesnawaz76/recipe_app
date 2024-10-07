import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.suffixIcon,
    this.validation,
    required this.controller,
    required this.hinttxt,
  });

  final String hinttxt;
  final TextEditingController controller;
  final IconData? suffixIcon; //?mark at end means value can be null
  final String? Function(String?)? validation;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validation,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff68D0D6)),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff68D0D6)),
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          labelText: hinttxt,
          hintStyle: const TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          suffixIcon: Icon(
            suffixIcon,
            color: const Color(0xff68D0D6),
          )),
    );
  }
}
