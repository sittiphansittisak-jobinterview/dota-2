import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  //widget
  late final _agisWidget = Container(
    width: MediaQuery.of(context).size.height / 2.5,
    height: MediaQuery.of(context).size.height / 2.5,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height),
      boxShadow: [BoxShadow(color: const Color.fromRGBO(98, 227, 253, 1).withAlpha(50), blurRadius: MediaQuery.of(context).size.height, spreadRadius: MediaQuery.of(context).size.height / 10)],
    ),
    child: Image.asset(ImageAssetPath.homePage.agis, fit: BoxFit.contain),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _agisWidget,
    );
  }
}
