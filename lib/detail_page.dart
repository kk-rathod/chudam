import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  DetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsly",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.article_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with styling and overlay text
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                      children: [
                        Image.network(
                          article['urlToImage'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              article['source']['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  // Title with enhanced typography
                  Text(
                    article['title'],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article['author']),
                      Text(article['publishedAt'])
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 20.0),
                  // Section title for description
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Article description with better padding
                  Text(
                    article['description'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  const Text(
                    "Content",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Article description with better padding
                  Text(
                    article['content'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  // Add a divider for extra separation
                  Divider(),
                  SizedBox(height: 20.0),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
