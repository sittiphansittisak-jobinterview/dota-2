import 'package:dota_2_client_flutter/controller/hero_overall_page_controller.dart';
import 'package:dota_2_client_flutter/model/hero_thumbnail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HeroOverallPage extends StatefulWidget {
  const HeroOverallPage({super.key});

  @override
  State<HeroOverallPage> createState() => _HeroOverallPageState();
}

class _HeroOverallPageState extends State<HeroOverallPage> with AutomaticKeepAliveClientMixin<HeroOverallPage> {
  //controller
  final _heroOverallPageController = Get.put(HeroOverallPageController());

  //widget builder
  Widget heroThumbnailWidgetBuilder(HeroThumbnailModel hero) {
    //controller
    final isHover = Rx(false);

    //widget property
    const width = 100.0;
    const height = 100.0;

    //widget
    final videoWidget = VideoPlayer(hero.video);
    hero.video.setLooping(true);

    return InkWell(
      onHover: (value) {
        if (value) {
          hero.video.play();
        } else {
          hero.video.pause();
          hero.video.seekTo(Duration.zero);
        }
        isHover.value = value;
      },
      onTap: () {},
      child: Obx(
        () => Transform.scale(
          scale: isHover.value ? 1.5 : 1,
          child: SizedBox(
            width: width,
            height: height,
            child: videoWidget,
          ),
        ),
      ),
    );
  }

  //widget
  late final heroThumbnailWidgetList = [for (final hero in _heroOverallPageController.heroThumbnailList) heroThumbnailWidgetBuilder(hero)];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 350),
        child: Column(
          children: [
            Expanded(
              //Don't use ListView because this page in the game shows all hero thumbnail.
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 15),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: heroThumbnailWidgetList,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(height: 55),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
