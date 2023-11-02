import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/view/index_view.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dota 2',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: IndexView(url: window.location.pathname ?? PageUrl.home), //Using route will make the overlapping of the home page when open routes these are not the home page.
    );
  }
}
