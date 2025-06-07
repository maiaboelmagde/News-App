enum NewsCategory {
  general('General', 'general'),
  business('Business', 'business'),
  entertainment('Entertainment', 'entertainment'),
  health('Health', 'health'),
  science('Science', 'science'),
  sports('Sports', 'sports'),
  technology('Technology', 'technology');

  final String displayName;
  final String apiQuery;

  const NewsCategory(this.displayName, this.apiQuery);

}


