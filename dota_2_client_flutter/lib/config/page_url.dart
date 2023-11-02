class PageUrl {
  static const home = '/';
  static const hero = '/hero';
  static const heroOverall = '/hero';
  static const heroManual = '/hero/manual';
  static const item = '/item';

  static const _allPageList = [home, hero, heroOverall, heroManual, item];
  static const heroSupPageList = [heroOverall, heroManual];

  static bool isPageUrl(String? url) => _allPageList.contains(url);
}
