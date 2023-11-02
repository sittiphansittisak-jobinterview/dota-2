import 'package:flutter/material.dart';

class ItemPageView extends StatefulWidget {
  const ItemPageView({super.key});

  @override
  State<ItemPageView> createState() => _ItemPageViewState();
}

class _ItemPageViewState extends State<ItemPageView> with AutomaticKeepAliveClientMixin<ItemPageView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Center(
      child: Text('ItemPageView'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
