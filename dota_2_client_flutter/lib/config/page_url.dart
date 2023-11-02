class PageUrl {
  static const index = '/';
  static const hero = '/hero';
  static const heroManual = '/hero/manual';
  static const item = '/item';

  static const _allPageList = [index, hero, heroManual, item];
  static const heroSupPageList = [heroManual];

  static bool isPageUrl(String? url) => _allPageList.contains(url);
}
