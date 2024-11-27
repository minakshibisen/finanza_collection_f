import 'package:finanza_collection_f/utils/loading_widget.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double height;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;
  final BuildContext context;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    this.borderColor = AppColors.primaryColor,
    required this.onPressed,
    required this.context,
    this.text = "",
    this.color = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.height = 50,
    this.isLoading = false,
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        if(!isLoading) {
          onPressed();
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              AppColors.primaryColor,
              Color.fromRGBO(24, 102, 169, 0.5803921568627451),
            ])),
        child: Center(
          child: isLoading ? const LoadingWidget(color: AppColors.textOnPrimary,) : Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
