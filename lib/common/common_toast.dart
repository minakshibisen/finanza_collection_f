import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class CommonToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    Color textColor = AppColors.textOnPrimary,
    ToastType toastType = ToastType.custom,
    Duration animDuration = const Duration(seconds: 3),
    Duration duration = const Duration(seconds: 3),
  }) {
    var titleStyle = TextStyle(fontWeight: FontWeight.bold, color: textColor);
    var descStyle = TextStyle(color: textColor);
    switch (toastType) {
      case ToastType.success:
        MotionToast.success(
          title: Text(title, style: titleStyle),
          description: Text(description, style: descStyle),
          toastDuration: duration,
          animationDuration: animDuration,
        ).show(context);
        break;
      case ToastType.error:
        MotionToast.error(
          title: Text(title, style: titleStyle),
          description: Text(description, style: descStyle),
          toastDuration: duration,
          animationDuration: animDuration,
        ).show(context);
        break;
      case ToastType.warning:
        MotionToast.warning(
          title: Text(title, style: titleStyle),
          description: Text(description, style: descStyle),
          toastDuration: duration,
          animationDuration: animDuration,
        ).show(context);
        break;
      case ToastType.info:
        MotionToast.info(
          title: Text(title, style: titleStyle),
          description: Text(description, style: descStyle),
          animationDuration: animDuration,
          toastDuration: duration,
        ).show(context);
        break;
      default:
        MotionToast(
          primaryColor: AppColors.primaryColor,
          displaySideBar: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          secondaryColor: AppColors.textOnPrimary,
          icon: Icons.info,
          title: Text(title, style: titleStyle),
          description: Text(description, style: descStyle),
          animationDuration: animDuration,
          toastDuration: duration,
        ).show(context);
        break;
    }
  }
}

enum ToastType { success, error, warning, info, custom }
