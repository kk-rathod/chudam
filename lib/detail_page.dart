import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isSaved = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkIfSaved() async {
    try {
      final query = await _firestore
          .collection('newsArticles')
          .where('title', isEqualTo: widget.article['title']) // Use title or unique identifier
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          isSaved = true;
        });
      }
    } catch (e) {
      print('Error checking saved status: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfSaved(); // Check save status when the screen loads
  }
  Future<void> deleteArticle(BuildContext context) async {
    try {
      final query = await _firestore
          .collection('newsArticles')
          .where('title', isEqualTo: widget.article['title'])
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }

      setState(() {
        isSaved = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article removed from saved items.')),
      );
    } catch (e) {
      print('Error deleting article: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove article: $e')),
      );
    }
  }
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to remove this article from saved items?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteArticle(context); // Proceed with deletion
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.black ),
              ),
            ),
          ],
        );
      },
    );
  }


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
          IconButton(
            onPressed: () async {
              if (isSaved) {
                // Show delete confirmation dialog
                showDeleteConfirmationDialog(context);
              } else {
                // Save the article if not already saved
                try {
                  await _firestore.collection('newsArticles').add(widget.article);
                  setState(() {
                    isSaved = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article saved successfully!')),
                  );
                } catch (e) {
                  print('Error saving article: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save article: $e')),
                  );
                }
              }
            },
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.black
            ),
          ),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.article['urlToImage'] ??
                              'https://th.bing.com/th/id/OIP.DZLWFqYqIG4l_yJaqOuJXgHaHa?rs=1&pid=ImgDetMain',
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
                              widget.article['source']['name'] ??
                                  'Unknown source',
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
                  const SizedBox(height: 12.0),
                  Text(
                    widget.article['title'] ?? 'NO title',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.article['author'] ?? 'Unknown author'),
                      Text(widget.article['publishedAt'] ?? 'Unknown time'),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.article['description'] ?? ' No description',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Content",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.article['content'] ?? 'No content',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
