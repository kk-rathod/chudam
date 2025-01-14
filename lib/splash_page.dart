import 'package:flutter/material.dart';
import 'login_page.dart';
import 'navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Function to navigate to the next screen after 3 seconds
  void _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('sign_or_login') ?? false;
    await Future.delayed(const Duration(seconds: 4));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isLoggedIn ? const NavigationPage() : const LoginPage()),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can change the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset('asserts/images/newsly.webp'), // Your logo or image
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Newsly!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
