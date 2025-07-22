import 'package:flutter/material.dart';
import 'package:store_app_v2/core/constants.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.mainColor),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          label: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(hintText),
          ),
          labelStyle: TextStyle(
            color: MyColors.matteCharcoal.withOpacity(0.6),
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
