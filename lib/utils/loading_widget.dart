import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingWidget({super.key, this.size = 20, this.color = AppColors.primaryColor});

  @override
  Widget build(BuildContext context) {
    var lineWidth = size * 0.15;
    if(size > 30) {
      lineWidth = size * 0.1;
    } else if (size > 50){
      lineWidth = size * 0.06;
    }
    return SpinKitRing(
      lineWidth: lineWidth,
      size: size, color: color,
    );
  }
}
