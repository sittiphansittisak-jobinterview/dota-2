import 'package:flutter/material.dart';

class HeroOverallPage extends StatefulWidget {
  const HeroOverallPage({super.key});

  @override
  State<HeroOverallPage> createState() => _HeroOverallPageState();
}

class _HeroOverallPageState extends State<HeroOverallPage> with AutomaticKeepAliveClientMixin<HeroOverallPage> {
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Text('HeroOverallPage: $_now'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
