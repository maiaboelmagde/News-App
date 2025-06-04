import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/hive_boxes_names.dart';
import 'package:news_app/core/extensions/string_extension.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({
    super.key,
    required this.article,
    required this.isBookmarked,
    this.onBookmarkPressed,
  });

  final NewsArticle article;
  final bool isBookmarked;
  final Function()? onBookmarkPressed;

  @override
  State<NewsDetails> createState() => _NewsDetailsState(isBookmarked:isBookmarked);
}

class _NewsDetailsState extends State<NewsDetails> {
  _NewsDetailsState({required this.isBookmarked });
  bool isBookmarked;
  @override
  Widget build(BuildContext context) {
    log(widget.article.content);
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
            imageUrl: widget.article.urlToImage ?? '',
            width: double.infinity,
            height: 228,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(width: double.infinity, color: Colors.grey.shade400),
            errorWidget: (_, __, ___) =>
                Container(width: 122, color: Colors.grey.shade400),
          ),
          Text(widget.article.title, style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              if (widget.article.urlToImage != null)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.article.urlToImage!),
                ),
              const SizedBox(width: 6),
              Text(
                widget.article.sourceName,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(width: 6),
              Text(
                widget.article.publishedAt.timeAgo,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Spacer(),
              IconButton(
                onPressed: () async{
                  await Share.share(widget.article.url);
                },
                icon: Icon(Icons.share_outlined),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  if (widget.onBookmarkPressed != null) {
                    widget.onBookmarkPressed!();
                  } else {
                    final box = Hive.box(HiveBoxesNames.bookmarks);
                    isBookmarked = !isBookmarked;
                    setState(() {
                      
                    });
                    if (widget.isBookmarked) {
                      box.delete(widget.article.url);
                    } else {
                      box.put(widget.article.url, widget.article);
                    }
                  }
                },
              ),
            ],
          ),
          Html(data: widget.article.description),
          Html(data: widget.article.content),
        ],
      ),
    );
  }
}
