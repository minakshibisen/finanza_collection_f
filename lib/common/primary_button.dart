import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          backgroundColor: color,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(280, 65),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
