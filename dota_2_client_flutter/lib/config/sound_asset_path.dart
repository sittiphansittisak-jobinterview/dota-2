class SoundAssetPath {
  static const list = [];

  static final appBar = _AppBar();

  static final allList = [...list, ...appBar.list];
}

class _AppBar {
  final menu = 'asset/sound/app_bar/menu.m4a';

  List<String> get list => [menu];
}
