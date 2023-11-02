import 'package:flutter/material.dart';

class ItemPageView extends StatefulWidget {
  const ItemPageView({super.key});

  @override
  State<ItemPageView> createState() => _ItemPageViewState();
}

class _ItemPageViewState extends State<ItemPageView> with AutomaticKeepAliveClientMixin<ItemPageView> {
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Text('ItemPageView: $_now'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
