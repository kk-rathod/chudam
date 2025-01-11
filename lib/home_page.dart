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

  // URLs for each category (update with your actual API URLs)
  final Map<String, String> categoryUrls = <String, String>{
    'Technology': 'https://newsapi.org/v2/top-headlines?category=technology&apiKey=b677b5097965477789753d46e8432683',
    'Sports': 'https://newsapi.org/v2/top-headlines?category=sports&apiKey=b677b5097965477789753d46e8432683',
    'Politics': 'https://newsapi.org/v2/top-headlines?category=politics&apiKey=b677b5097965477789753d46e8432683',
  };

  Future<void> loadArticles() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching articles
    });

    final url = categoryUrls[selectedButton]!;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Parse the JSON
        setState(() {
          articles = data['articles']; // Assign articles to the state variable
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors if needed
      print('Error: $e');
    }
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      selectedButton = buttonText;
      articles = []; // Clear the existing articles
    });
    loadArticles(); // Fetch new articles for the selected category
  }

  @override
  void initState() {
    super.initState();
    loadArticles(); // Load articles for the initial category (Technology)
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
        leading: Icon(Icons.newspaper),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => onButtonPressed('Technology'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == 'Technology'
                          ? Colors.black
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text('Technology'),
                  ),
                  ElevatedButton(
                    onPressed: () => onButtonPressed('Sports'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == 'Sports'
                          ? Colors.black
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text('Sports'),
                  ),
                  ElevatedButton(
                    onPressed: () => onButtonPressed('Politics'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == 'Politics'
                          ? Colors.black
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text('Politics'),
                  )
                ],
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
