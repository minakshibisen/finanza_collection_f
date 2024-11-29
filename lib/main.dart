import 'package:finanza_collection_f/splash_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// const BaseUrl = "https://uat.bridgelogicsoftware.com/2009/api/";
const BaseUrl = "http://172.17.1.1/2009/api/";

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

        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
