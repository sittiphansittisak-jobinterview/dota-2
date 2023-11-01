import 'package:dota_2_client_flutter/model/hero_thumbnail_model.dart';

class HeroDatabase {
  static Future<List<HeroThumbnailModel>?> getThumbnailList() async {
    final data = [
      {
        'name': 'Abaddon',
        'video': 'asset/video/hero/npc_dota_hero_abaddon.webm',
      },
    ];
    return data.map((e) => HeroThumbnailModel.fromJson(e)).toList();
  }
}
