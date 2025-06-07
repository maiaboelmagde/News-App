import 'package:flutter/material.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';

class NewsProvider with ChangeNotifier{
  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();
  bool _isLoadingEverything = true;
  List<NewsArticle> _newsArticles = [];
  String? _newsErrorMessage;

  List<NewsArticle> get newsArticles =>_newsArticles;
  bool get isLoadingEverything => _isLoadingEverything;
  String? get newsErrorMessage => _newsErrorMessage;


  Future<void>fetchNews({required String query})async{
    _isLoadingEverything = true;
    try{
      _newsArticles = await _repository.fetchEverything(query: query);
    }catch(e){
      _newsArticles = [];
      _newsErrorMessage='FAILED TO Fech Articles';
    }
    _isLoadingEverything = false;
    notifyListeners();
  }

}
