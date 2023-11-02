import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart';

class HeroPageController extends GetxController {
  //initial
  bool get isAllInitialized => _isTabControllerInitialized;
  bool _isTabControllerInitialized = false;

  String? initialTab({required Function({required String url}) updateIndexTabByUrl}) {
    if (_isTabControllerInitialized) return 'ไม่สามารถโหลดข้อมูล tab hero ซ้ำได้';

    this.updateIndexTabByUrl = updateIndexTabByUrl;

    _isTabControllerInitialized = true;
    if (isAllInitialized) update();
    return null;
  }

  //tab
  late final Function({required String url}) updateIndexTabByUrl;
  String _currentPageUrl = PageUrl.heroOverall;

  String get currentPageUrl => _currentPageUrl;

  set currentPageUrl(String value) {
    _currentPageUrl = PageUrl.isPageUrl(value) ? value : PageUrl.home;
    _updateUrl();
    _updateTab();
  }

  void _updateTab() {
    updateIndexTabByUrl(url: currentPageUrl);
  }

  void _updateUrl() {
    String title = 'Dota 2 - hero';
    switch (currentPageUrl) {
      case PageUrl.heroOverall:
        title = title;
        break;
      case PageUrl.heroManual:
        title = '$title manual';
        break;
    }
    window.history.replaceState(null, title, currentPageUrl);
  }

  Future goToOverallPage() async {
    if (currentPageUrl == PageUrl.heroOverall) return;
    currentPageUrl = PageUrl.heroOverall;
    update();
  }

  Future goToManualPage() async {
    if (currentPageUrl == PageUrl.heroManual) return;
    currentPageUrl = PageUrl.heroManual;
    update();
  }
}
