import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/controller/app_bar_controller.dart';
import 'package:dota_2_client_flutter/controller/index_controller.dart';
import 'package:dota_2_client_flutter/view/app_bar_view.dart';
import 'package:dota_2_client_flutter/view/hero_page_view.dart';
import 'package:dota_2_client_flutter/view/home_page_view_.dart';
import 'package:dota_2_client_flutter/view/item_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class IndexView extends StatefulWidget {
  final String url;

  const IndexView({super.key, required this.url});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> with SingleTickerProviderStateMixin {
  //controller
  final _indexController = Get.put(IndexController());
  final _appBarController = Get.put(AppBarController());
  late final _tabController = TabController(length: _pageMap.length, vsync: this);

  //logic function
  void _updateIndexTabByUrl({required String url}) {
    final index = _pageMap.keys.toList().indexOf(url);
    if (index == -1) return; //for some url that I don't want to change tab.
    _tabController.animateTo(index);
  }

  //widget
  final _pageMap = {
    PageUrl.index: const HomePageView(),
    PageUrl.hero: const HeroPageView(),
    PageUrl.item: const ItemPageView(),
  };

  @override
  void initState() {
    super.initState();
    final url = widget.url; //to prevent widget.url that will auto change to '/' from not using the route in the MaterialApp.
    Future.delayed(Duration.zero, () async {
      final initialResultList = [
        _appBarController.initialTab(updateIndexTabByUrl: _updateIndexTabByUrl),
        ...await Future.wait([
          _indexController.initialAsset(context),
          _indexController.initialHeroThumbnail(),
          _appBarController.initialSound(),
        ]),
      ];
      initialResultList.whereType<String>().forEach((debugPrint)); //to track error
      _indexController.initialFinish();

      _appBarController.getCurrentPageUrlFromBrowser(url);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(
      init: _indexController,
      builder: (indexController) {
        //If app is not initialized, show logo
        if (!indexController.isInitializationFinish) {
          final logoWidget = Image.asset(ImageAssetPath.dota2Logo, width: MediaQuery.of(context).size.width / 2, height: MediaQuery.of(context).size.height / 2);
          return Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Center(child: logoWidget)));
        }

        //If app is initialized but some initialized are failed, show message
        if (!indexController.isAllInitialized || !_appBarController.isAllInitialized) {
          const textWidget = Text(
            'เกิดข้อผิดพลาดในการเตรียมความพร้อมของแอป',
            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, fontFamily: FontFamilyStyle.mainThai),
          );
          return const Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Center(child: textWidget)));
        }

        //If app is initialized but the user has not seen the intro video, show intro video
        if (!indexController.isUserSeenIntroVideo) {
          final videoWidget = VideoPlayer(indexController.introVideo);
          final homeButtonWidget = GestureDetector(
            onTap: indexController.closeIntroVideo,
            child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
          );
          indexController.playIntroVideo();
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
        return SafeArea(
          child: Scaffold(
            appBar: const AppBarView(),
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
