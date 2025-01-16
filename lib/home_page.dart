import 'package:flutter/material.dart';
import 'package:events/profile_page.dart';
import 'package:events/detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<dynamic> articles = [];
  String selectedButton = 'Technology';
  bool isLoading = false;
  final List<String> categories = [
    'Technology',
    'Health',
    'Sports',
    'Science',
    'Politics',
    'Business',
    'Entertainment',
    'General',
  ];


  Future<void> loadArticles(String query) async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://newsapi.org/v2/everything?q=$query&apiKey=b677b5097965477789753d46e8432683';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {

      print('Error: $e');
    }
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      selectedButton = buttonText;
      articles = [];
    });
    loadArticles(buttonText);
  }

  @override
  void initState() {
    super.initState();
    loadArticles(selectedButton); 
  }

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
      body: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedButton == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ElevatedButton(
                      onPressed: () => onButtonPressed(category),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isSelected ? Colors.black : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        title: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                article['urlToImage'] ?? 'https://th.bing.com/th/id/OIP.DZLWFqYqIG4l_yJaqOuJXgHaHa?rs=1&pid=ImgDetMain' ,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article['source']['name'] ?? "Unknown source",
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                article['title'] ?? 'No title',
                                style:
                                const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10, ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article['author'] ?? 'Unknown author'),
                                Text(article['publishedAt'] ?? 'Unknown time')
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

