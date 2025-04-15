import 'package:flutter/material.dart';
import 'package:store_app_v2/core/constants.dart';

class StrikethroughText extends StatelessWidget {
  final String text;

  const StrikethroughText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: MyColors.gray,
          ),
        ),
        Positioned(
          top: 8, // Adjust this value to change the position of the line
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: MyColors.gray, // Adjust the color of the line if needed
          ),
        ),
      ],
    );
  }
}
