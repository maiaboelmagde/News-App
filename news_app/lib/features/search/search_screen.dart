import 'package:flutter/material.dart';
import 'package:news_app/core/provider/news_provider.dart';
import 'package:provider/provider.dart';

/// Done : Task - Add Controller To It
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // List<NewsArticle> _articles = [];
  // bool _isLoading = false;
  // String? _errorMessage;

   Future<void> _searchNews(String query) async {
    Provider.of<NewsProvider>(context, listen: false).fetchNews(query: query);

    // if (query.isEmpty) {
    //   setState(() {
    //     _articles = [];
    //     _errorMessage = null;
    //   });
    //   return;
    // }

    // setState(() {
    //   _isLoading = true;
    //   _errorMessage = null;
    // });

    // try {
    //   final repository = locator<BaseNewsApiRepository>();
    //   final articles = await repository.fetchEverything(query: query);
    //   setState(() {
    //     _articles = articles;
    //     _isLoading = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     _errorMessage = 'Failed to load news: $e';
    //     _isLoading = false;
    //   });
    // }
  }


  @override
  Widget build(BuildContext context) {
    final newsProvider=Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Search News')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onSubmitted: _searchNews,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child:
                  newsProvider.isLoadingEverything
                      ? const Center(child: CircularProgressIndicator())
                      : newsProvider.newsErrorMessage != null
                      ? Center(child: Text(newsProvider.newsErrorMessage!))
                      : newsProvider.newsArticles.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                        itemCount:newsProvider.newsArticles.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.newsArticles[index];
                          return ListTile(
                            leading:
                                article.urlToImage != null
                                    ? Image.network(
                                      article.urlToImage!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image_not_supported),
                                    )
                                    : Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade400,
                                    ),
                            title: Text(article.title),
                            subtitle: Text(
                              '${article.sourceName} • ${article.publishedAt.toString()}',
                            ),
                            onTap: () {
                              // TODO: Navigate to article details screen
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
