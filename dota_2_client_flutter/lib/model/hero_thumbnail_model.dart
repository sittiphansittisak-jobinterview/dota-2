import 'package:video_player/video_player.dart';

class HeroThumbnailModel {
  final String name;
  final VideoPlayerController video;

  HeroThumbnailModel({required this.name, required this.video});

  factory HeroThumbnailModel.fromJson(Map<String, dynamic> json) {
    return HeroThumbnailModel(
      name: json['name'],
      video: VideoPlayerController.asset(json['video']),
    );
  }
}
