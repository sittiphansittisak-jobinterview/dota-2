class PageUrl {
  static const home = '/';
  static const hero = '/hero';
  static const item = '/item';

  static const _allPageList = [home, hero, item];

  static bool isPageUrl(String? url) => _allPageList.contains(url);
}
