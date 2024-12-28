import 'package:flutter/material.dart';

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with black border and shadow effect
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75), // Circular image
                child: const Image(
                  image: AssetImage('asserts/images/profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name with larger and bolder text
            const Text(
              'Bhukya Koushik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Black text for name
              ),
            ),
            const SizedBox(height: 8),

            // Bio with grey text and center alignment
            const Text(
              'Welcome to your profile! Explore the app and enjoy the experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,  // Grey text for bio
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            // Email with grey color
            const Text(
              'Email: bhukya.koushik@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,  // Grey text for email
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
