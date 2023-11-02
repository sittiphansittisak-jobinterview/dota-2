import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/controller/hero_page_controller.dart';
import 'package:dota_2_client_flutter/view/hero_manual_page.dart';
import 'package:dota_2_client_flutter/view/hero_overall_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroPageView extends StatefulWidget {
  final String url;

  const HeroPageView({super.key, required this.url});

  @override
  State<HeroPageView> createState() => _HeroPageViewState();
}

class _HeroPageViewState extends State<HeroPageView> with AutomaticKeepAliveClientMixin<HeroPageView>, SingleTickerProviderStateMixin {
  //controller
  final _heroPageController = Get.put(HeroPageController());
  late final _tabController = TabController(length: _pageMap.length, vsync: this);

  //logic function
  void _updateIndexTabByUrl({required String url}) {
    final index = _pageMap.keys.toList().indexOf(url);
    if (index == -1) return; //for some url that I don't want to change tab.
    _tabController.animateTo(index);
  }

  //widget property
  final _menuTextSize = 20.0;
  final _menuTextColor = const Color.fromRGBO(93, 113, 116, 1);
  final _menuTextHighLightColor = Colors.white;
  final _menuTextFontFamily = FontFamilyStyle.mainThai;

  //widget builder
  Widget menuWidgetBuilder({required bool isHighLight, required String tabName, required Function() onTap}) {
    if (isHighLight) {
      return Text(tabName,
          style: TextStyle(
            color: _menuTextHighLightColor,
            fontSize: _menuTextSize,
            fontFamily: _menuTextFontFamily,
            shadows: [Shadow(color: _menuTextHighLightColor, blurRadius: 5)],
          ));
    }

    final isHover = Rx(false);
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onHover: (value) => isHover.value = value,
        onTap: onTap,
        child: Obx(
          () => Text(
            tabName,
            style: TextStyle(
              color: isHover.value ? _menuTextHighLightColor : _menuTextColor,
              fontSize: _menuTextSize,
              fontFamily: _menuTextFontFamily,
            ),
          ),
        ));
  }

  //widget
  late final _overallMenuWidget = GetBuilder(init: _heroPageController, builder: (heroPageController) => menuWidgetBuilder(isHighLight: heroPageController.currentPageUrl == PageUrl.heroOverall, tabName: 'ฮีโร่', onTap: heroPageController.goToOverallPage));
  late final _manualMenuWidget = GetBuilder(init: _heroPageController, builder: (heroPageController) => menuWidgetBuilder(isHighLight: heroPageController.currentPageUrl == PageUrl.heroManual, tabName: 'คู่มือ', onTap: heroPageController.goToManualPage));
  late final _menuDividerWidget = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      '/',
      style: TextStyle(color: _menuTextColor, fontSize: _menuTextSize, fontFamily: _menuTextFontFamily),
    ),
  );
  final _pageMap = {
    PageUrl.heroOverall: const HeroOverallPage(),
    PageUrl.heroManual: const HeroManualPage(),
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final initialResultList = [
        _heroPageController.initialTab(updateIndexTabByUrl: _updateIndexTabByUrl),
      ];
      initialResultList.whereType<String>().forEach((debugPrint)); //to track error

      _heroPageController.currentPageUrl = widget.url;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 550),
            _overallMenuWidget,
            _menuDividerWidget,
            _manualMenuWidget,
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: DefaultTabController(
              length: _pageMap.length,
              child: TabBarView(
                controller: _tabController,
                children: _pageMap.values.toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
