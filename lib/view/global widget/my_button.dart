import 'package:flutter/material.dart';
import 'package:store_app_v2/core/constants.dart';

class MyButton extends StatelessWidget {
  final String text;
  const MyButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.elsie,
        borderRadius: BorderRadius.circular(16),
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 100.0,
          vertical: 8.0,
        ),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: MyColors.white)),
      ),
    );
  }
}
