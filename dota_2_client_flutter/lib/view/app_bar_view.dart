import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:dota_2_client_flutter/config/image_asset_path.dart';
import 'package:dota_2_client_flutter/config/page_url.dart';
import 'package:dota_2_client_flutter/controller/app_bar_controller.dart';
import 'package:dota_2_client_flutter/controller/dota_plus_controller.dart';
import 'package:dota_2_client_flutter/utility/string_formatter.dart';
import 'package:dota_2_client_flutter/widget/container/clip_shadow_path_widget.dart';
import 'package:dota_2_client_flutter/widget/dialog/show_question_yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarView extends StatefulWidget implements PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  State<AppBarView> createState() => _AppBarViewState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppBarViewState extends State<AppBarView> with SingleTickerProviderStateMixin {
  //controller
  final _appBarController = Get.put(AppBarController());
  final _dotaPlusController = Get.put(DotaPlusController())..getPoint();
  late int _dotaPlusOldPoint = _dotaPlusController.point;
  final _isMouseOverHomeButton = Rx(false);
  final _isMouseOverSettingButton = Rx(false);
  final _isMouseOverExitButton = Rx(false);
  final _isMouseOverDotaPlusPointButton = Rx(false);

  //controller animation
  late final _homeMenuAnimationController = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat(reverse: true);
  late final _blurRadiusAnimation = Tween<double>(begin: 20, end: 40).animate(_homeMenuAnimationController);
  late final _spreadRadiusAnimation = Tween<double>(begin: 20, end: 40).animate(_homeMenuAnimationController);

  @override
  void dispose() {
    _homeMenuAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //widget property
    const appBarFullHeight = 100.0;
    const appBarHeight = 80.0;
    const appBarBgColor = Color.fromRGBO(6, 6, 9, 1);
    const pageRouteButtonWidth = 20.0;
    const homeMenuWidth = 290.0;
    const homeMenuDistance = 20.0;
    const textMenuColor = Color.fromRGBO(97, 109, 116, 1);
    const textMenuHoverColor = Color.fromRGBO(134, 150, 160, 1);
    const textMenuHighLightColor = Color.fromRGBO(84, 114, 152, 1);
    const textMenuWidth = 220.0;
    const textMenuDistance = 25.0;
    final textMenuBorderPath = Path()
      ..moveTo(textMenuDistance, 0) // Top-left corner
      ..lineTo(textMenuWidth + textMenuDistance, 0) // Top-right corner
      ..lineTo(textMenuWidth, appBarHeight) // Bottom-right corner
      ..lineTo(0, appBarHeight); // Bottom-left corner
    const imageMenuNavigatorWidth = 15.0;
    const imageMenuHomeWidth = 70.0;
    const imageMenuHomeAreaColor = Color.fromRGBO(39, 31, 28, 1);
    const imageMenuHomeAreaShadow = BoxShadow(blurRadius: 25, color: Color.fromRGBO(10, 10, 10, 1), offset: Offset(0, -10));
    const imageMenuHomeButtonAreaColor = Color.fromRGBO(47, 34, 30, 1);
    const imageMenuImageWidth = 35.0;
    const imageMenuButtonWidth = 100.0;
    const imageMenuDistance = 30.0;
    const imageMenuBgColor = Color.fromRGBO(21, 25, 31, 1);
    const imageMenuBorderColor = Color.fromRGBO(44, 48, 55, 1);
    const imageMenuColor = Color.fromRGBO(97, 109, 116, 1);
    const imageMenuMuteColor = Color.fromRGBO(18, 18, 18, 1);
    const imageMenuHoverColor = Color.fromRGBO(134, 150, 160, 1);
    const imageMenuDotaPlusBgColor = Color.fromRGBO(64, 54, 22, 1);
    const imageMenuDotaPlusBorderColor = Color.fromRGBO(72, 61, 30, 1);
    const imageMenuExitColor = Color.fromRGBO(40, 15, 15, 1);
    const imageMenuDotaPlusPointTextColor = Color.fromRGBO(220, 208, 135, 1);
    const imageMenuDotaPlusPointIconColor = Color.fromRGBO(184, 138, 71, 1);
    final imageMenuBorderPath = Path()
      ..moveTo(imageMenuDistance, 0) // Top-left corner
      ..lineTo(imageMenuButtonWidth + imageMenuDistance, 0) // Top-right corner
      ..lineTo(imageMenuButtonWidth, appBarHeight) // Bottom-right corner
      ..lineTo(0, appBarHeight); // Bottom-left corner

    //widget builder
    Widget textMenuWidgetBuilder({bool isHighlightText = false, required String text, required Function()? onTap}) {
      final isMouseOver = Rx(false);
      const buttonWidth = textMenuWidth + textMenuDistance;

      final textWidget = Obx(() => Text(text, style: TextStyle(color: isMouseOver.value || isHighlightText ? textMenuHoverColor : textMenuColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: FontFamilyStyle.mainThai, shadows: const [Shadow(color: Colors.black, blurRadius: 2)])));

      return ClipShadowPathWidget(
        clipper: _TextMenuClipper(),
        borderPath: textMenuBorderPath,
        border: Border.all(color: appBarBgColor.withOpacity(isHighlightText ? 0.8 : 0.4), width: isHighlightText ? 5.5 : 3.5),
        child: InkWell(
          onHover: (value) => isMouseOver.value = value,
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: buttonWidth,
            child: isHighlightText
                ? Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(buttonWidth * 2), boxShadow: [BoxShadow(color: textMenuHighLightColor.withAlpha(50), blurRadius: 50, spreadRadius: 50)]),
                    child: textWidget,
                  )
                : textWidget,
          ),
        ),
      );
    }

    Widget imageMenuWidgetBuilder({required Color bgColor, required Color borderColor, required Color? imageColor, required Color? imageHoverColor, required String image, required Function()? onTap}) {
      final isMouseOver = Rx(false);

      return ClipShadowPathWidget(
        clipper: _ImageMenuClipper(),
        borderPath: imageMenuBorderPath,
        border: Border.all(color: borderColor, width: 4),
        shadow: const BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1),
        child: InkWell(
          onHover: (value) => isMouseOver.value = value,
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: imageMenuButtonWidth + imageMenuDistance,
            color: bgColor,
            foregroundDecoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: const [0, 0.5], colors: [Colors.black.withOpacity(0.5), Colors.transparent])),
            child: Obx(() => Image.asset(image, color: isMouseOver.value ? imageHoverColor : imageColor, width: imageMenuImageWidth, fit: BoxFit.contain)),
          ),
        ),
      );
    }

    //widget
    final appBarBgWidget = Container(
      height: appBarHeight,
      decoration: BoxDecoration(
        color: appBarBgColor,
        boxShadow: const [BoxShadow(blurRadius: 0.1, spreadRadius: 0.1)],
        border: Border(bottom: BorderSide(color: appBarBgColor.withAlpha(200), width: 2)),
        gradient: const RadialGradient(
          colors: [imageMenuHomeButtonAreaColor, appBarBgColor],
          center: Alignment(-0.365, 5),
          radius: 7.0,
        ),
      ),
    );
    final settingButtonWidget = InkWell(
      onHover: (value) => _isMouseOverSettingButton.value = value,
      onTap: () {},
      child: Obx(() => Image.asset(ImageAssetPath.appBar.settingMenu, color: _isMouseOverSettingButton.value ? textMenuHoverColor : textMenuColor, width: imageMenuImageWidth, fit: BoxFit.contain)),
    );
    final verticalDivider1Widget = Container(width: 1, height: 45, color: const Color.fromRGBO(0, 0, 0, 1));
    final verticalDivider2Widget = Container(width: 1, height: 45, color: const Color.fromRGBO(48, 44, 44, 1));
    final previousButtonWidget = GetBuilder<AppBarController>(
      init: _appBarController,
      builder: (controller) {
        final canClick = controller.previousPageList.isNotEmpty;
        if (!canClick) return SizedBox(width: pageRouteButtonWidth, child: Image.asset(ImageAssetPath.appBar.previousMenu, color: imageMenuMuteColor, width: imageMenuNavigatorWidth));
        final isMouseOver = Rx(false);
        return InkWell(
          onTap: controller.goToPreviousPage,
          onHover: (value) => isMouseOver.value = value,
          child: Obx(() => SizedBox(width: pageRouteButtonWidth, child: Image.asset(ImageAssetPath.appBar.previousMenu, color: isMouseOver.value ? imageMenuHoverColor : imageMenuColor, width: imageMenuNavigatorWidth))),
        );
      },
    );
    final forwardButtonWidget = GetBuilder<AppBarController>(
      init: _appBarController,
      builder: (controller) {
        final canClick = controller.forwardPageList.isNotEmpty;
        if (!canClick) return SizedBox(width: pageRouteButtonWidth, child: Image.asset(ImageAssetPath.appBar.forwardMenu, color: imageMenuMuteColor, width: imageMenuNavigatorWidth));
        final isMouseOver = Rx(false);
        return InkWell(
          onTap: controller.goToForwardPage,
          onHover: (value) => isMouseOver.value = value,
          child: Obx(() => SizedBox(width: pageRouteButtonWidth, child: Image.asset(ImageAssetPath.appBar.forwardMenu, color: isMouseOver.value ? imageMenuHoverColor : imageMenuColor, width: imageMenuNavigatorWidth))),
        );
      },
    );
    final homeAreaWidget = ClipShadowPathWidget(clipper: _HomeMenuClipper1(), border: Border.all(color: imageMenuHomeAreaColor, width: 5), shadow: imageMenuHomeAreaShadow, child: Container(width: homeMenuWidth, height: 90, color: imageMenuHomeAreaColor));
    final homeMenuAreaWidget = ClipShadowPathWidget(clipper: _HomeMenuClipper2(), border: Border.all(color: imageMenuHomeButtonAreaColor, width: 5), shadow: imageMenuHomeAreaShadow, child: Container(width: 215, height: 100, color: imageMenuHomeButtonAreaColor));
    final homeMenuWidget = InkWell(
      onHover: (value) => _isMouseOverHomeButton.value = value,
      onTap: _appBarController.goToHomePage,
      child: GetBuilder<AppBarController>(
        init: _appBarController,
        builder: (controller) {
          final url = controller.setCurrentPageUrl;
          final isCurrentPage = url == PageUrl.home;

          final homeMenuWidget = ShaderMask(
            shaderCallback: (Rect bounds) {
              return RadialGradient(
                colors: [
                  const Color.fromRGBO(255, 212, 90, 1).withOpacity(isCurrentPage ? 1 : 0.1),
                  const Color.fromRGBO(213, 70, 22, 1).withOpacity(isCurrentPage ? 1 : 0.1),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Image.asset(ImageAssetPath.appBar.homeMenu, width: imageMenuHomeWidth, fit: BoxFit.contain),
          );
          if (isCurrentPage) {
            return AnimatedBuilder(
              animation: _homeMenuAnimationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageMenuHomeWidth * 2),
                    boxShadow: [BoxShadow(color: const Color.fromRGBO(214, 45, 49, 1).withAlpha(80), blurRadius: _blurRadiusAnimation.value, spreadRadius: _spreadRadiusAnimation.value)],
                  ),
                  child: homeMenuWidget,
                );
              },
            );
          }

          return Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(imageMenuHomeWidth * 2),
                boxShadow: [BoxShadow(color: const Color.fromRGBO(214, 45, 49, 1).withAlpha(80), blurRadius: 25, spreadRadius: _isMouseOverHomeButton.value ? 25 : 0)],
              ),
              child: homeMenuWidget,
            ),
          );
        },
      ),
    );
    final heroMenuWidget = GetBuilder<AppBarController>(
      init: _appBarController,
      builder: (controller) => textMenuWidgetBuilder(
        isHighlightText: controller.setCurrentPageUrl == PageUrl.hero,
        text: controller.heroPageText,
        onTap: controller.goToHeroPage,
      ),
    );
    final itemMenuWidget = GetBuilder<AppBarController>(
      init: _appBarController,
      builder: (controller) => textMenuWidgetBuilder(
        isHighlightText: controller.setCurrentPageUrl == PageUrl.item,
        text: controller.itemPageText,
        onTap: controller.goToItemPage,
      ),
    );
    final dotaPlusPointButtonWidget = InkWell(
      onHover: (value) => _isMouseOverDotaPlusPointButton.value = value,
      onTap: () {},
      child: Row(
        children: [
          Image.asset(ImageAssetPath.appBar.dotaPlusPointMenu, width: 30, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Obx(
            () {
              final blurRadius = _isMouseOverDotaPlusPointButton.value ? 4.0 : 2.0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.5),
                    child: GetBuilder<DotaPlusController>(
                        init: _dotaPlusController,
                        builder: (controller) {
                          Widget pointWidgetBuilder(value) => Text(
                                StringFormatter.numberWithCommas(value, decimalPlaces: 0) ?? '0',
                                style: TextStyle(
                                  color: imageMenuDotaPlusPointTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: FontFamilyStyle.mainThai,
                                  shadows: [Shadow(color: imageMenuDotaPlusPointTextColor, blurRadius: blurRadius)],
                                ),
                              );
                          if (controller.point == _dotaPlusOldPoint) return pointWidgetBuilder(controller.point);
                          final begin = _dotaPlusOldPoint;
                          final end = controller.point;
                          _dotaPlusOldPoint = controller.point;
                          return TweenAnimationBuilder<int>(
                            tween: IntTween(begin: begin, end: end),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, child) {
                              return pointWidgetBuilder(value);
                            },
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 50,
                      color: imageMenuDotaPlusPointIconColor,
                      shadows: [Shadow(color: imageMenuDotaPlusPointIconColor, blurRadius: blurRadius)],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    final mailMenuWidget = imageMenuWidgetBuilder(
      bgColor: imageMenuBgColor,
      borderColor: imageMenuBorderColor,
      imageColor: imageMenuColor,
      imageHoverColor: imageMenuHoverColor,
      image: ImageAssetPath.appBar.mailMenu,
      onTap: () {},
    );
    final inventoryMenuWidget = imageMenuWidgetBuilder(
      bgColor: imageMenuBgColor,
      borderColor: imageMenuBorderColor,
      imageColor: imageMenuColor,
      imageHoverColor: imageMenuHoverColor,
      image: ImageAssetPath.appBar.inventoryMenu,
      onTap: () {},
    );
    final dotaPlusMenuWidget = imageMenuWidgetBuilder(
      bgColor: imageMenuDotaPlusBgColor,
      borderColor: imageMenuDotaPlusBorderColor,
      imageColor: null,
      imageHoverColor: null,
      image: ImageAssetPath.appBar.dotaPlusMenu,
      onTap: () {},
    );
    final exitMenuWidget = ClipShadowPathWidget(
      clipper: _MenuFarRightClipper(),
      border: Border.all(color: const Color.fromRGBO(70, 28, 28, 1), width: 4),
      child: InkWell(
        onTap: () async => (await showQuestionYesNoDialog(context: context, title: 'ยืนยันการออก', detail: 'คุณต้องการจะออกจาก Dota 2 หรือไม่?', yesText: 'ใช่', noText: 'ไม่') ?? false) ? _appBarController.closeApp() : null,
        onHover: (value) => _isMouseOverExitButton.value = value,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20),
          width: imageMenuButtonWidth,
          color: imageMenuExitColor,
          child: Obx(
            () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageMenuImageWidth * 2),
                  boxShadow: [BoxShadow(color: const Color.fromRGBO(214, 45, 49, 1).withAlpha(80), blurRadius: _isMouseOverExitButton.value ? 20 : 10, spreadRadius: _isMouseOverExitButton.value ? 10 : 5)],
                ),
                child: Image.asset(ImageAssetPath.appBar.exitMenu, width: imageMenuImageWidth, fit: BoxFit.contain)),
          ),
        ),
      ),
    );
    final textMenuWidgetList = [heroMenuWidget, itemMenuWidget];
    final imageMenuRightWidgetList = [mailMenuWidget, inventoryMenuWidget, dotaPlusMenuWidget, exitMenuWidget];

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: appBarFullHeight,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Stack(
        children: [
          appBarBgWidget,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: appBarHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 50),
                    settingButtonWidget,
                    const SizedBox(width: 20),
                    verticalDivider1Widget,
                    const SizedBox(width: 1),
                    verticalDivider2Widget,
                    const SizedBox(width: 20),
                    previousButtonWidget,
                    const SizedBox(width: 15),
                    forwardButtonWidget,
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  SizedBox(
                    height: appBarHeight,
                    child: Row(
                      children: [
                        const SizedBox(width: homeMenuWidth - homeMenuDistance),
                        SizedBox(
                          width: textMenuWidth * textMenuWidgetList.length + textMenuDistance * (textMenuWidgetList.length - 1),
                          child: Stack(children: [for (var i = 0; i < textMenuWidgetList.length; i++) Padding(padding: EdgeInsets.only(left: textMenuWidth * i), child: textMenuWidgetList[i])]),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      homeAreaWidget,
                      homeMenuAreaWidget,
                      Center(child: homeMenuWidget),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: appBarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      const SizedBox(width: 10),
                      dotaPlusPointButtonWidget,
                      const SizedBox(width: 10),
                      SizedBox(
                        width: imageMenuButtonWidth * imageMenuRightWidgetList.length,
                        child: Stack(children: [for (var i = 0; i < imageMenuRightWidgetList.length; i++) Padding(padding: EdgeInsets.only(left: imageMenuButtonWidth * i), child: imageMenuRightWidgetList[i])]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _HomeMenuClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const distance = 20.0;
    final path = Path();
    path.moveTo(0, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width - distance, size.height); // Bottom-right corner
    path.lineTo(distance, size.height); // Bottom-left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HomeMenuClipper1 oldClipper) => false;
}

class _HomeMenuClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const distance = 10.0;
    final path = Path();
    path.moveTo(0, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width - distance, size.height); // Bottom-right corner
    path.lineTo(distance, size.height); // Bottom-left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HomeMenuClipper2 oldClipper) => false;
}

class _TextMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const distance = 25.0;
    final path = Path();
    path.moveTo(distance, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width - distance, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Close the path to complete the parallelogram shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _ImageMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const distance = 30.0;
    final path = Path();
    path.moveTo(distance, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width - distance, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Close the path to complete the parallelogram shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _MenuFarRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const distance = 30.0;
    final path = Path();
    path.moveTo(distance, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Close the path to complete the parallelogram shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
