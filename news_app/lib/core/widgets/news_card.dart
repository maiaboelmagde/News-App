import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/extensions/date_extension.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/news_details_screen/details_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isBookmarked;
  final Function()? onBookmarkPressed;

  const NewsCard({
    super.key,
    required this.article,
    this.isBookmarked = false,
    this.onBookmarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return NewsDetails(article: article);
          }));
        },
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              width: 122,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 122, color: Colors.grey.shade400),
              errorWidget:
                  (_, __, ___) => Container(width: 122, color: Colors.grey.shade400),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
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
                      Expanded(
                        child: Text(
                          article.sourceName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
        
                      Row(
                        children: [
                          Text(
                            article.publishedAt.timeAgo,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          IconButton(
                            icon: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color:
                              isBookmarked
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              if (onBookmarkPressed != null) {
                                onBookmarkPressed!();
                              } else {
                                final box = Hive.box(HiveBoxesNames.bookmarks);
                                if (isBookmarked) {
                                  box.delete(article.url);
                                } else {
                                  box.put(article.url, article);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
