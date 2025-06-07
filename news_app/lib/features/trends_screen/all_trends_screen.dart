import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/provider/headlines_provider.dart';
import 'package:news_app/core/widgets/news_card.dart';
import 'package:provider/provider.dart';

class AllTrendsScreen extends StatelessWidget {
  const AllTrendsScreen({super.key});

  @override
Widget build(BuildContext context) {
  final newsProvider = Provider.of<HeadlinesProvider>(context);
  return Scaffold(
    appBar: AppBar(title: Text("Trending News")),
    body: ValueListenableBuilder(
      valueListenable: Hive.box(HiveBoxesNames.bookmarks).listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          itemCount: newsProvider.topHeadlines.length,
          itemBuilder: (context, index) {
            final article = newsProvider.topHeadlines[index];
            final isBookmarked = box.containsKey(article.url);
            return NewsCard(
              article: article,
              isBookmarked: isBookmarked,
            );
          },
        );
      },
    ),
  );
}

}