import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/view/hero_manual_page.dart';
import 'package:dota_2_client_flutter/view/hero_overall_page.dart';
import 'package:flutter/material.dart';

class HeroPageView extends StatefulWidget {
  final String page;

  const HeroPageView({super.key, this.page = PageUrl.hero});

  @override
  State<HeroPageView> createState() => _HeroPageViewState();
}

class _HeroPageViewState extends State<HeroPageView> with AutomaticKeepAliveClientMixin<HeroPageView>, SingleTickerProviderStateMixin {
  //controller
  late final _pageIndex = widget.page;
  late final _tabController = TabController(length: _pageMap.length, vsync: this /*, animationDuration: const Duration(microseconds: 1)*/);

  //widget property
  final _menuTextSize = 20.0;
  final _menuTextColor = const Color.fromRGBO(93, 113, 116, 1);
  final _menuTextFontFamily = FontFamilyStyle.mainThai;

  //widget builder
  Widget menuWidgetBuilder({required bool isHighLight, required String tabName}) {
    return Text(
      tabName,
      style: TextStyle(color: isHighLight ? Colors.white : _menuTextColor, fontSize: _menuTextSize, fontFamily: _menuTextFontFamily),
    );
  }

  //widget
  late final _overallMenuWidget = menuWidgetBuilder(isHighLight: false, tabName: 'ฮีโร่');
  late final _manualMenuWidget = menuWidgetBuilder(isHighLight: false, tabName: 'คู่มือ');
  late final _menuDividerWidget = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      '/',
      style: TextStyle(color: _menuTextColor, fontSize: _menuTextSize, fontFamily: _menuTextFontFamily),
    ),
  );
  final _pageMap = {
    PageUrl.hero: const HeroOverallPage(),
    PageUrl.heroManual: const HeroManualPage(),
  };

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _tabController.animateTo(_pageMap.keys.toList().indexOf(_pageIndex));
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
