import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/provider/headlines_provider.dart';
import 'package:news_app/core/provider/news_provider.dart';
import 'package:news_app/core/widgets/news_card.dart';
import 'package:news_app/features/home/models/news_category.dart';
import 'package:news_app/features/home/widgets/category_list_widget.dart';
import 'package:news_app/features/home/widgets/trending_news_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsCategory selectedCategory = NewsCategory.general;

  final List<NewsCategory> categories = NewsCategory.values;

  @override
  void initState() {
    super.initState();
    _loadNews();
    _loadHeadlines();
  }

  Future<void> _loadNews() async {
    Provider.of<NewsProvider>(
      context,
      listen: false,
    ).fetchNews(query: selectedCategory.apiQuery);
  }

  Future<void> _loadHeadlines() async {
    Provider.of<HeadlinesProvider>(
      context,
      listen: false,
    ).fetchTopHeadlines(category: selectedCategory.apiQuery);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final headlinesProvider = Provider.of<HeadlinesProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TrendingNews(
              isLoading: headlinesProvider.isLoadingHeadlines,
              articles: headlinesProvider.topHeadlines,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CategoryList(
                categories: categories.map((e) => e.displayName).toList(),
                selectedCategory: selectedCategory.displayName,
                onCategorySelected: (category) {
                  setState(
                    () => selectedCategory = NewsCategory.values.firstWhere(
                      (e) => e.displayName == category,
                      orElse: () => NewsCategory.general,
                    ),
                  );
                  _loadNews();
                  _loadHeadlines();
                },
              ),
            ),
          ),
          newsProvider.isLoadingEverything
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box(
                      HiveBoxesNames.bookmarks,
                    ).listenable(),
                    builder: (context, Box box, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newsProvider
                            .newsArticles
                            .length,
                        itemBuilder: (context, index) {
                          final article = newsProvider
                              .newsArticles[index];
                          final isBookmarked = box.containsKey(article.url);
                          return NewsCard(
                            article: article,
                            isBookmarked: isBookmarked,
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
