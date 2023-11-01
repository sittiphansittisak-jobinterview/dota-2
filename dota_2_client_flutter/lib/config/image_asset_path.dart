class ImageAssetPath {
  static const dota2Logo = 'asset/image/dota_2_logo.png';
  static const list = [dota2Logo];

  static final appBar = _AppBar();
  static final homePage = _HomePage();

  static final allList = [...list, ...appBar.list, ...homePage.list];
}

class _AppBar {
  final settingMenu = 'asset/image/app_bar/setting_menu.png';
  final previousMenu = 'asset/image/app_bar/previous_menu.png';
  final forwardMenu = 'asset/image/app_bar/forward_menu.png';
  final homeMenu = 'asset/image/app_bar/home_menu.png';
  final dotaPlusPointMenu = 'asset/image/app_bar/dota_plus_point_menu.png';
  final mailMenu = 'asset/image/app_bar/mail_menu.png';
  final inventoryMenu = 'asset/image/app_bar/inventory_menu.png';
  final dotaPlusMenu = 'asset/image/app_bar/dota_plus_menu.png';
  final exitMenu = 'asset/image/app_bar/exit_menu.png';

  List<String> get list => [settingMenu, previousMenu, forwardMenu, homeMenu, dotaPlusPointMenu, mailMenu, inventoryMenu, dotaPlusMenu, exitMenu];
}

class _HomePage {
  final agis = 'asset/image/home_page/agis.png';

  List<String> get list => [agis];
}
