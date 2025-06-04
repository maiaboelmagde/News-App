import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/extensions/string_extension.dart';
import 'package:news_app/core/widgets/news_card.dart';
import 'package:news_app/features/search/search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchScreen({super.key});


  // List<NewsArticle> _articles = [];
  // bool _isLoading = false;
  // String? _errorMessage;

  // Future<void> _searchNews(String query) async {
  //   Provider.of<SearchProvider>(context, listen: false).fetchNews(query: query);

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
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      child: Builder(
        
        builder: (context){
          final searchProvider = Provider.of<SearchProvider>(context);
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    searchProvider.fetchNews(query: value);
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: searchProvider.isLoadingEverything
                      ? const Center(child: CircularProgressIndicator())
                      : searchProvider.newsErrorMessage != null
                          ? Center(child: Text(searchProvider.newsErrorMessage!))
                          : searchProvider.articles.isEmpty
                              ? const Center(child: Text('No results found'))
                              : NewsListView(newsProvider: searchProvider),
                ),
              ],
            ),
          ),
        );
        }
      ),
    );
  }
}

class NewsListView extends StatelessWidget {
  const NewsListView({
    super.key,
    required this.newsProvider,
  });

  final SearchProvider newsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HiveBoxesNames.bookmarks).listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          itemCount: newsProvider.articles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.articles[index];
            final isBookmarked = box.containsKey(article.url);
            return NewsCard(
              article: article,
              isBookmarked: isBookmarked,
              formatTimeAgo: (time) => time.timeAgo,
            );
          },
        );
      },
    );
  }
}
