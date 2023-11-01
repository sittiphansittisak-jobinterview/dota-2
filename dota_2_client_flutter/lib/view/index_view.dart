import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/controller/index_controller.dart';
import 'package:dota_2_client_flutter/view/app_bar_view.dart';
import 'package:dota_2_client_flutter/view/hero_page_view.dart';
import 'package:dota_2_client_flutter/view/home_page_view_.dart';
import 'package:dota_2_client_flutter/view/item_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class IndexView extends StatefulWidget {
  final bool isInitial;

  const IndexView({super.key, this.isInitial = false});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> with SingleTickerProviderStateMixin {
  //controller
  final _indexController = Get.put(IndexController());
  late final _tabController = TabController(length: _pageMap.length, vsync: this /*, animationDuration: const Duration(microseconds: 1)*/);

  //widget
  late final _appBarWidget = const AppBarView();
  final _pageMap = {
    PageUrl.home: const HomePageView(),
    PageUrl.hero: const HeroPageView(),
    PageUrl.item: const ItemPageView(),
  };

  @override
  void initState() {
    super.initState();
    if (!widget.isInitial) return;
    _indexController.getCurrentPageUrlFromBrowser();
    Future.delayed(Duration.zero, () async {
      final initialResultList = await Future.wait([
        _indexController.initialAsset(context),
        _indexController.initialHeroThumbnail(),
      ]);
      for (final item in initialResultList) {
        if (item != null) debugPrint(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(
      init: _indexController,
      builder: (controller) {
        //If app is not initialized, show logo
        if (!controller.isAppInitialized) {
          final logoWidget = Image.asset(ImageAssetPath.dota2Logo, width: MediaQuery.of(context).size.width / 2, height: MediaQuery.of(context).size.height / 2);
          return Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Center(child: logoWidget)));
        }

        //If app is initialized but the user has not seen the intro video, show intro video
        if (!controller.isUserSeenIntroVideo) {
          final videoWidget = VideoPlayer(controller.introVideo);
          final homeButtonWidget = GestureDetector(
            onTap: controller.closeIntroVideo,
            child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
          );
          controller.playIntroVideo();
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  videoWidget,
                  homeButtonWidget, //This is a hack to make the video player clickable
                ],
              ),
            ),
          );
        }

        //If app is initialized and the user has seen the intro video, show main page
        if (!_pageMap.keys.contains(controller.currentPageUrl)) controller.currentPageUrl = PageUrl.home; //if current page is not in page map, set current page to home page
        controller.updateUrl(); //update url before show new page. This can make sure that the url and the page are the same.
        controller.playMenuSound(); //every time the page changes, play menu sound
        _tabController.animateTo(_pageMap.keys.toList().indexOf(controller.currentPageUrl));
        return SafeArea(
          child: Scaffold(
            appBar: _appBarWidget,
            backgroundColor: Colors.black,
            body: DefaultTabController(
              length: _pageMap.length,
              child: TabBarView(
                controller: _tabController,
                children: _pageMap.values.toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
