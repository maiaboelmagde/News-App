import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/extensions/date_extension.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetails extends StatelessWidget {
  const NewsDetails({
    super.key,
    required this.article,
    this.onBookmarkPressed,
  });

  final NewsArticle article;
  final Function()? onBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    log(article.content ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? '',
            width: double.infinity,
            height: 228,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(width: double.infinity, color: Colors.grey.shade400),
            errorWidget: (_, __, ___) =>
                Container(width: 122, color: Colors.grey.shade400),
          ),
          Text(
            article.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              if (article.urlToImage != null)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(article.urlToImage!),
                ),
              const SizedBox(width: 6),
              Text(
                article.sourceName,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(width: 6),
              Text(
                article.publishedAt.timeAgo,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  await Share.share(article.url);
                },
                icon: Icon(Icons.share_outlined),
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box(
                  HiveBoxesNames.bookmarks,
                ).listenable(),
                builder: (context, box, _) {
                  bool isBookmarked = box.containsKey(article.url);
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      if (onBookmarkPressed != null) {
                        onBookmarkPressed!();
                      } else {
                        isBookmarked = !isBookmarked;
                        if (isBookmarked) {
                          box.delete(article.url);
                        } else {
                          box.put(article.url, article);
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Html(data: article.description),
          Html(data: article.content),
        ],
      ),
    );
  }
}
