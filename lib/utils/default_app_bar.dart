import 'package:flutter/material.dart';

import 'colors.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Size size;

  const DefaultAppBar({super.key, required this.title, required this.size});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      shadowColor: Colors.transparent,
      toolbarHeight: size.height,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(10)),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
            ),
          ),
        ),
      ),
      leadingWidth: size.width * 0.19,
      titleSpacing: -2,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size.width * 0.05),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(size.height * 0.09);
}
