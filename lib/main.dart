import 'package:deltamovies/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF161B22),
        accentColor: const Color(0xFF21262D),
        canvasColor: const Color(0xFF30363D),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Color(0xFF484F58),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}


