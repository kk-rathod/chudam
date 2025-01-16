import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  final Function(String, String, String) onUpdateProfile;

  const UpdateProfile({
    super.key,
    required this.onUpdateProfile,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController urlController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    urlController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      descriptionController.text = prefs.getString('description') ?? '';
      urlController.text = prefs.getString('url') ??
          'https://th.bing.com/th/id/OIP.4nF9zdAz6qdA0XM2T16_CgHaNK?rs=1&pid=ImgDetMain';
    });
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('description', descriptionController.text);
    await prefs.setString('url', urlController.text);

    // Call the onUpdateProfile callback to pass the data back
    widget.onUpdateProfile(
      nameController.text,
      descriptionController.text,
      urlController.text,
    );

    Navigator.pop(context); // Return to the previous screen
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.description),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'Profile URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.link),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 200,
        child: FloatingActionButton(
          onPressed: _saveProfile,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.black,
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
