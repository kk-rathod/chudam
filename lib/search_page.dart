import 'package:flutter/material.dart';
import 'package:events/profile_page.dart';

class search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsly",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.search),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const profile()));
            },
            icon: Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            suffixIcon: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
