import 'dart:developer';

import 'package:hive/hive.dart';

part 'news_article_model.g.dart';

@HiveType(typeId: 0)
class NewsArticle {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String? urlToImage;

  @HiveField(3)
  final String sourceName;

  @HiveField(4)
  final DateTime publishedAt;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String content	;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.sourceName,
    required this.publishedAt,
    required this.url,
    required this.content
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    log('$json');
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'],
      urlToImage: json['urlToImage'],
      sourceName: json['source']['name'] ?? 'Unknown',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      url: json['url'] ?? '',
      content	: json['content'] ?? 'no content'
    );
  }
}
