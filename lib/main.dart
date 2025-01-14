
import 'package:events/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    title: "NEWSLY",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.grey[400],
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[200],
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black, // Button text color
            overlayColor: Colors.orange
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Black text for body
        titleMedium: TextStyle(color: Colors.black87), // Slightly darker grey for subtitles
      ),
    ),
    home: SplashScreen(),
  ));
}

