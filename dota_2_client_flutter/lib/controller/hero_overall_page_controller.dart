import 'package:dota_2_client_flutter/storage/hero_thumbnail_storage.dart';
import 'package:get/get.dart';

class HeroOverallPageController extends GetxController {
  get heroThumbnailList => HeroThumbnailStorage.list;
}
