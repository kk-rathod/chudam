import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:events/profile_page.dart';
import 'package:events/detail_page.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;
  String errorMessage = '';


  // Method to fetch search results from the API
  Future<void> searchArticles(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
    });

    final url = 'https://newsapi.org/v2/everything?q=$query&apiKey=b677b5097965477789753d46e8432683';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = data['articles'];
          isLoading = false;
        });

        if (searchResults.isEmpty) {
          setState(() {
            errorMessage = 'No results found for "$query".';
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: Unable to fetch articles. Please try again later.';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsly",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const profile()),
              );
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search for articles...',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          searchArticles(_controller.text);
                        }
                      },
                      icon: const Icon(Icons.search_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final article = searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(5.0),
                            title: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child:FadeInImage.assetNetwork(
                                    placeholder: 'assets/loading.gif', // Placeholder image
                                    image: article['urlToImage'] ??
                                        'https://th.bing.com/th/id/OIP.DZLWFqYqIG4l_yJaqOuJXgHaHa?rs=1&pid=ImgDetMain', // Image URL
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
          if (isLoading)
            Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }



}
