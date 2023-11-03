import 'package:dota_2_client_flutter/config/hero_name.dart';
import 'package:dota_2_client_flutter/config/video_asset_path.dart';
import 'package:dota_2_client_flutter/model/hero_thumbnail_model.dart';

class HeroDatabase {
  static Future<List<HeroThumbnailModel>?> getThumbnailList() async {
    final data = HeroName.basicList
        .map<Map<String, dynamic>>((e) => {
              'name': e,
              'video': VideoAssetPath.heroPage.getPathByHeroName(e),
            })
        .toList();
    return data.map((e) => HeroThumbnailModel.fromJson(e)).toList();
  }
}
