import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:dota_2_client_flutter/config/video_asset_path.dart';
import 'package:dota_2_client_flutter/database/hero_database.dart';
import 'package:dota_2_client_flutter/storage/hero_thumbnail_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class IndexController extends GetxController {
  //app initialization
  bool get isAllInitialized => isInitializationFinish && _isAssetInitializationSuccess && _isHeroThumbnailInitializationSuccess;
  bool isInitializationFinish = false; //finish all initialization on init state(not mean success).
  bool _isAssetInitializationSuccess = false;
  bool _isHeroThumbnailInitializationSuccess = false;

  void initialFinish() {
    isInitializationFinish = true;
    update();
  }

  Future<String?> initialAsset(BuildContext context) async {
    if (_isAssetInitializationSuccess) return 'ไม่สามารถโหลดข้อมูล Asset ซ้ำได้';

    //all image
    for (final item in ImageAssetPath.allList) {
      await precacheImage(Image.asset(item).image, context);
    }

    //intro video
    await introVideo.initialize();
    introVideo.addListener(() {
      //If video play finish, set isUserSeenIntroVideo to true
      if (_isIntroVideoPlayed && !introVideo.value.isPlaying && !introVideo.value.isBuffering) {
        closeIntroVideo();
      }
    });

    _isAssetInitializationSuccess = true;
    if (isAllInitialized) update();
    return null;
  }

  Future<String?> initialHeroThumbnail() async {
    if (_isHeroThumbnailInitializationSuccess) return 'ไม่สามารถโหลดข้อมูล hero thumbnail ซ้ำได้';

    //all thumbnail hero
    final heroThumbnailList = await HeroDatabase.getThumbnailList();
    if (heroThumbnailList == null) return 'เกิดข้อผิดพลาดในการโหลดข้อมูล hero thumbnail';
    if (!await HeroThumbnailStorage.saveAndInitialHeroThumbnail(heroThumbnailList)) return 'เกิดข้อผิดพลาดในการบันทึกข้อมูล hero thumbnail';

    _isHeroThumbnailInitializationSuccess = true;
    if (isAllInitialized) update();
    return null;
  }

  //intro video
  final introVideo = VideoPlayerController.asset(VideoAssetPath.dota2Intro);
  bool _isIntroVideoPlayed = false; //prevent skipping the intro video with addListener
  bool isUserSeenIntroVideo = false;

  Future playIntroVideo() async {
    if (_isIntroVideoPlayed) return;
    await introVideo.play();
    _isIntroVideoPlayed = true;
  }

  Future closeIntroVideo() async {
    if (isUserSeenIntroVideo) return;
    isUserSeenIntroVideo = true;
    await introVideo.pause();
    await introVideo.dispose();
    update();
  }
}
