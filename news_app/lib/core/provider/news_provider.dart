import 'package:flutter/material.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';

class NewsProvider with ChangeNotifier{
  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();
  bool _isLoadingEverything = true;
  List<NewsArticle> _newsArticles = [];
  String? _newsErrorMessage;
  // bool _isLoadingHeadlines = true;
  // List<NewsArticle> _topHeadlines = [];
  // String _headlinesErrorMessage = '';
  

  List<NewsArticle> get newsArticles =>_newsArticles;
  // List<NewsArticle> get topHeadlines => _topHeadlines;
  bool get isLoadingEverything => _isLoadingEverything;
  // bool get isLoadingHeadlines => _isLoadingHeadlines;
  String? get newsErrorMessage => _newsErrorMessage;
  // String get headlinesErrorMessage => _headlinesErrorMessage;


  Future<void>fetchNews({required String query})async{
    _isLoadingEverything = true;
    try{
      _newsArticles = await _repository.fetchEverything(query: 'news');
    }catch(e){
      _newsArticles = [];
      _newsErrorMessage='FAILED TO Fech Articles';
    }
    _isLoadingEverything = false;
    notifyListeners();
  }

  // Future<void>fetchTopHeadlines({required String category})async{
  //   _isLoadingHeadlines = true;
  //   try{
  //     _topHeadlines = await _repository.fetchTopHeadlines(category: category);
  //   }catch(e){
  //     _topHeadlines = [];
  //     log('No thing returned at NewsProvider, fetchTopHeadlines');
  //   }
  //   _isLoadingHeadlines = false;
  //   notifyListeners();
  // }

}