import 'package:flutter/material.dart';
import 'package:events/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _ProfileState();
}

class _ProfileState extends State<profile> {
  String name = '';
  String email = '';
  String description = '';
  String url =
      "https://th.bing.com/th/id/OIP.4nF9zdAz6qdA0XM2T16_CgHaNK?rs=1&pid=ImgDetMain";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load data from shared preferences
  Future<void> _loadProfileData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name') ?? '';
      email = pref.getString('email') ?? '';
      description = pref.getString('description') ?? '';
      url = pref.getString('url') ??
          "https://th.bing.com/th/id/OIP.4nF9zdAz6qdA0XM2T16_CgHaNK?rs=1&pid=ImgDetMain";
    });
  }

  // Update profile data
  void _updateProfile(String newName, String newEmail, String newDescription,
      String newUrl) async {
    setState(() {
      name = newName;
      email = newEmail;
      description = newDescription;
      url = newUrl;
    });

    // Save updated data to SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('name', newName);
    await pref.setString('email', newEmail);
    await pref.setString('description', newDescription);
    await pref.setString('url', newUrl);
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfile(
                    onUpdateProfile: _updateProfile,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 150),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // Name
            Text(
              name.isEmpty ? 'No Name' : name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description.isEmpty ? 'No Description' : description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            // Email
            Text(
              email.isEmpty ? 'No Email' : email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
