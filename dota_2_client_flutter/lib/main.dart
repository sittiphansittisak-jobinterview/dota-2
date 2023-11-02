import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/view/index_view.dart';
import 'package:flutter/material.dart';
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
      home: const IndexView(isInitial: true),
      //this routes is fixing the issue of the navigation on the web when open the app from a url
      routes: {
        PageUrl.hero: (context) => const IndexView(),
        PageUrl.item: (context) => const IndexView(),
      },
    );
  }
}
