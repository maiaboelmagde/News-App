import 'package:flutter/material.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';

class HeadlinesProvider with ChangeNotifier {
  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();

  bool _isLoadingHeadlines = true;
  List<NewsArticle> _topHeadlines = [];
  String _headlinesErrorMessage = '';
  

  List<NewsArticle> get topHeadlines => _topHeadlines;
  bool get isLoadingHeadlines => _isLoadingHeadlines;
  String get headlinesErrorMessage => _headlinesErrorMessage;

  Future<void> fetchTopHeadlines({required String category}) async {
    _isLoadingHeadlines = true;
    try {
      _topHeadlines = await _repository.fetchTopHeadlines(category: category);
    } catch (e) {
      _topHeadlines = [];
      _headlinesErrorMessage = 'Failed to featch Top Headlines';
    }
    _isLoadingHeadlines = false;
    notifyListeners();
  }
}
