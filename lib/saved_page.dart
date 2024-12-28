import 'package:flutter/material.dart';
import 'package:events/profile_page.dart';

class save extends StatelessWidget {
  const save({super.key});

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Newsly",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            leading: Icon(Icons.save),
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
          body: const Center(
            child: Text('No saved articles yet!'),
          ),
        );

  }
}