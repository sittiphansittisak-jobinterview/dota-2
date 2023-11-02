import 'dart:io';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import "package:universal_html/html.dart";
import 'package:soundpool/soundpool.dart';
import 'package:dota_2_client_flutter/config/sound_asset_path.dart';

class AppBarController extends GetxController {
  //app bar initial
  bool get isAllInitialized => _isSoundInitialized;
  bool _isSoundInitialized = false;

  Future<String?> initialSound() async {
    if (_isSoundInitialized) return 'ไม่สามารถโหลดข้อมูล sound ซ้ำได้';

    //page menu sound
    _pageMenuSound = _soundPool.load(await rootBundle.load(SoundAssetPath.appBar.menu));

    _isSoundInitialized = true;
    if (isAllInitialized) update();
    return null;
  }

  //menu text
  final heroPageText = 'ฮีโร่';
  final itemPageText = 'ไอเทม';

  //sound
  final _soundPool = Soundpool.fromOptions();
  int? _soundStreamId;
  late Future<int> _pageMenuSound;

  Future _playPageMenuSound() async {
    if (_soundStreamId != null) await _soundPool.stop(_soundStreamId!);
    _soundStreamId = await _soundPool.play(await _pageMenuSound);
  }

  //route URL
  final previousPageList = <String>[];
  final forwardPageList = <String>[];
  String _currentPageUrl = PageUrl.home;

  String get setCurrentPageUrl => _currentPageUrl;

  set setCurrentPageUrl(String value) {
    _currentPageUrl = PageUrl.isPageUrl(value) ? value : PageUrl.home;
    _updateUrl();
  }

  void _updateUrl() {
    String title = 'Dota 2';
    switch (setCurrentPageUrl) {
      case PageUrl.home:
        title = 'Dota 2';
        break;
      case PageUrl.hero:
        title = 'Dota 2 - $heroPageText';
        break;
      case PageUrl.item:
        title = 'Dota 2 - $itemPageText';
        break;
    }
    window.history.replaceState(null, title, setCurrentPageUrl);
  }

  void getCurrentPageUrlFromBrowser() {
    final url = window.location.pathname;
    if (!PageUrl.isPageUrl(url)) return;
    setCurrentPageUrl = url!;
  }

  Future goToPreviousPage() async {
    if (previousPageList.isEmpty) return;
    forwardPageList.add(setCurrentPageUrl);
    setCurrentPageUrl = previousPageList.last;
    previousPageList.removeLast();
    _playPageMenuSound();
    update();
  }

  Future goToForwardPage() async {
    if (forwardPageList.isEmpty) return;
    previousPageList.add(setCurrentPageUrl);
    setCurrentPageUrl = forwardPageList.last;
    forwardPageList.removeLast();
    _playPageMenuSound();
    update();
  }

  Future goToHomePage() async {
    if (setCurrentPageUrl == PageUrl.home) return;
    previousPageList.add(setCurrentPageUrl);
    setCurrentPageUrl = PageUrl.home;
    forwardPageList.clear();
    _playPageMenuSound();
    update();
  }

  Future goToHeroPage() async {
    if (setCurrentPageUrl == PageUrl.hero) return;
    previousPageList.add(setCurrentPageUrl);
    setCurrentPageUrl = PageUrl.hero;
    forwardPageList.clear();
    _playPageMenuSound();
    update();
  }

  Future goToItemPage() async {
    if (setCurrentPageUrl == PageUrl.item) return;
    previousPageList.add(setCurrentPageUrl);
    setCurrentPageUrl = PageUrl.item;
    forwardPageList.clear();
    _playPageMenuSound();
    update();
  }

  Future closeApp() async {
    try {
      await SystemNavigator.pop();
    } catch (e) {
      debugPrint('closeApp error on SystemNavigator.pop: $e');
      try {
        exit(0);
      } catch (e) {
        debugPrint('closeApp error on exit(0): $e');
      }
    }
  }
}
