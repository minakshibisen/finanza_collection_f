
import 'package:finanza_collection_f/ui/LocationScreen.dart';
import 'package:finanza_collection_f/ui/detail_screen.dart';
import 'package:finanza_collection_f/ui/homeScreen.dart';
import 'package:finanza_collection_f/ui/login_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanza Collection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.workSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home:   const LoginScreen(),
    );
  }
}


