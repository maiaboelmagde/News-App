import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/widgets/news_card.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(HiveBoxesNames.bookmarks).listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No bookmarked articles yet'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final article = box.getAt(index);
              return NewsCard(
                article: article,
                isBookmarked: true,
                onBookmarkPressed: () {
                  box.deleteAt(index);
                },
              );
            },
          );
        },
      ),
    );
  }
}
