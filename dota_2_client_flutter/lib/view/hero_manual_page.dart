import 'package:flutter/material.dart';

class HeroManualPage extends StatefulWidget {
  const HeroManualPage({super.key});

  @override
  State<HeroManualPage> createState() => _HeroManualPageState();
}

class _HeroManualPageState extends State<HeroManualPage> with AutomaticKeepAliveClientMixin<HeroManualPage> {
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Text('HeroManualPage: $_now'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
