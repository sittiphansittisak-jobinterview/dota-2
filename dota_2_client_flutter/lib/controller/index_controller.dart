import 'dart:io';
import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/config/sound_asset_path.dart';
import 'package:dota_2_client_flutter/database/hero_database.dart';
import 'package:dota_2_client_flutter/storage/hero_thumbnail_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:video_player/video_player.dart';
import "package:universal_html/html.dart";

class IndexController extends GetxController {
  //app initialization
  bool get isAppInitialized => _isAssetInitialized && _isHeroThumbnailInitialized;
  bool _isAssetInitialized = false;
  bool _isHeroThumbnailInitialized = false;

  Future<String?> initialAsset(BuildContext context) async {
    if (_isAssetInitialized) return 'ไม่สามารถโหลดข้อมูล Asset ซ้ำได้';

    //all image
    for (final item in ImageAssetPath.allList) {
      await precacheImage(Image.asset(item).image, context);
    }

    //intro video
    await introVideo.initialize();
    introVideo.addListener(() {
      //If video play finish, set isUserSeenIntroVideo to true
      if (_isIntroVideoPlayed && !introVideo.value.isPlaying && !introVideo.value.isBuffering) {
        isUserSeenIntroVideo = true;
        update();
      }
    });

    //app bar sound
    _menuSound = _soundPool.load(await rootBundle.load(SoundAssetPath.appBar.menu));

    _isAssetInitialized = true;
    if (isAppInitialized) update();
    return null;
  }

  Future<String?> initialHeroThumbnail() async {
    if (_isHeroThumbnailInitialized) return 'ไม่สามารถโหลดข้อมูล hero thumbnail ซ้ำได้';

    //all thumbnail hero
    final heroThumbnailList = await HeroDatabase.getThumbnailList();
    if (heroThumbnailList == null) return 'เกิดข้อผิดพลาดในการโหลดข้อมูล hero thumbnail';
    HeroThumbnailStorage.list.addAll(heroThumbnailList);
    for (int index = 0; index < HeroThumbnailStorage.list.length; index++) {
      await HeroThumbnailStorage.list[index].video.initialize();
    }

    _isHeroThumbnailInitialized = true;
    if (isAppInitialized) update();
    return null;
  }

  //intro video
  final introVideo = VideoPlayerController.asset('asset/video/dota_2_opening.mp4');
  bool _isIntroVideoPlayed = false; //prevent skipping the intro video with addListener
  bool isUserSeenIntroVideo = false;

  Future playIntroVideo() async {
    if (_isIntroVideoPlayed) return;
    await introVideo.play();
    _isIntroVideoPlayed = true;
  }

  Future closeIntroVideo() async {
    if (isUserSeenIntroVideo) return;
    await introVideo.pause();
    await introVideo.dispose();
    isUserSeenIntroVideo = true;
    update();
  }

  //app bar sound
  final _soundPool = Soundpool.fromOptions();
  int? _soundStreamId;
  late Future<int> _menuSound;

  Future playMenuSound() async {
    if (_soundStreamId != null) await _soundPool.stop(_soundStreamId!);
    _soundStreamId = await _soundPool.play(await _menuSound);
  }

  //page route
  final heroPageText = 'ฮีโร่';
  final itemPageText = 'ไอเทม';
  String currentPageUrl = PageUrl.home;
  final previousPageList = <String>[];
  final forwardPageList = <String>[];

  void updateUrl() {
    String title = 'Dota 2';
    switch (currentPageUrl) {
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
    window.history.replaceState(null, title, currentPageUrl);
  }

  void getCurrentPageUrlFromBrowser() {
    final url = window.location.pathname;
    if (!PageUrl.isPageUrl(url)) return;
    currentPageUrl = url!;
  }

  Future goToPreviousPage() async {
    if (previousPageList.isEmpty) return;
    forwardPageList.add(currentPageUrl);
    currentPageUrl = previousPageList.last;
    previousPageList.removeLast();
    update();
  }

  Future goToForwardPage() async {
    if (forwardPageList.isEmpty) return;
    previousPageList.add(currentPageUrl);
    currentPageUrl = forwardPageList.last;
    forwardPageList.removeLast();
    update();
  }

  Future goToHomePage() async {
    if (currentPageUrl == PageUrl.home) return;
    previousPageList.add(currentPageUrl);
    currentPageUrl = PageUrl.home;
    forwardPageList.clear();
    update();
  }

  Future goToHeroPage() async {
    if (currentPageUrl == PageUrl.hero) return;
    previousPageList.add(currentPageUrl);
    currentPageUrl = PageUrl.hero;
    forwardPageList.clear();
    update();
  }

  Future goToItemPage() async {
    if (currentPageUrl == PageUrl.item) return;
    previousPageList.add(currentPageUrl);
    currentPageUrl = PageUrl.item;
    forwardPageList.clear();
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
