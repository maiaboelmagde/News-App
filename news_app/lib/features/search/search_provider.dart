
import 'package:flutter/material.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';

class SearchProvider with ChangeNotifier{
  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();

  bool _isLoadingEverything = false;
  List<NewsArticle> _articles = [];
  String? _newsErrorMessage = null;
  // bool _isLoadingHeadlines = true;
  // List<NewsArticle> _topHeadlines = [];
  // String _headlinesErrorMessage = '';
  

  List<NewsArticle> get articles =>_articles;
  // List<NewsArticle> get topHeadlines => _topHeadlines;
  bool get isLoadingEverything => _isLoadingEverything;
  // bool get isLoadingHeadlines => _isLoadingHeadlines;
  String? get newsErrorMessage => _newsErrorMessage;
  // String get headlinesErrorMessage => _headlinesErrorMessage;


  Future<void>fetchNews({required String query})async{
    _isLoadingEverything = true;
    notifyListeners ();
    try{
      _articles = await _repository.fetchEverything(query: query);
    }catch(e){
      _articles = [];
      _newsErrorMessage='FAILED TO Fech Articles';
    }
    _isLoadingEverything = false;
    notifyListeners();
  }

}