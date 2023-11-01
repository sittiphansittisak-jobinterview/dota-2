import 'package:get/get.dart';

class DotaPlusController extends GetxController {
  int point = 0;

  Future getPoint() async {
    await Future.delayed(const Duration(seconds: 1)); //Fetch from API
    point = 100000;
    update();
  }
}
