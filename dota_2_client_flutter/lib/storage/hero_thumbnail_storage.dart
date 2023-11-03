import 'package:dota_2_client_flutter/model/hero_thumbnail_model.dart';
import 'package:flutter/material.dart';

class HeroThumbnailStorage {
  static final list = <HeroThumbnailModel>[];

  static Future<bool> saveAndInitialHeroThumbnail(List<HeroThumbnailModel> heroThumbnailList) async {
    try{
      for (final item in heroThumbnailList) {
        list.add(item);
        await list[list.length - 1].video.initialize();
      }
      return true;
    }catch(e){
      debugPrint('Error on HeroThumbnailStorage.saveAndInitialHeroThumbnail: $e');
      return false;
    }
  }
}
