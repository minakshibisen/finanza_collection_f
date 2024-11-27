import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      lineWidth: size * 0.15,
      size: size, color: Colors.white,
    );
  }
}
