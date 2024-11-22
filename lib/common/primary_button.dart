import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  String text;
  Color color;
  Color textColor;
  Color borderColor;
  VoidCallback onPressed;
  BuildContext context;

  PrimaryButton({
    super.key,
    required this.borderColor,
    required this.onPressed,
    required this.context,
    this.text = "",
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(context) {
   return GestureDetector(
     onTap: onPressed,
     child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              AppColors.primaryColor,
              Color.fromRGBO(
                  24, 102, 169, 0.5803921568627451),
            ])),
        child:  Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
   );
  }
}
