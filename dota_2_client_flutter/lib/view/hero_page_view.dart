import 'package:flutter/material.dart';

class HeroPageView extends StatefulWidget {
  const HeroPageView({super.key});

  @override
  State<HeroPageView> createState() => _HeroPageViewState();
}

class _HeroPageViewState extends State<HeroPageView> with AutomaticKeepAliveClientMixin<HeroPageView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final testList = [for (int i = 0; i < 1000; i++) i];
    return ListView.builder(
      itemCount: testList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(testList[index].toString()),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
