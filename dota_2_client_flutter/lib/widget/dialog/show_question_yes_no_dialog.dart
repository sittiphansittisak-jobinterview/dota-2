import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showQuestionYesNoDialog({required BuildContext context, required String title, required String detail, required String yesText, required String noText}) async {
  return await showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      //animation
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      //widget property
      const textFontFamily = FontFamilyStyle.mainThai;

      //widget builder
      Widget buttonBuilder({required String text, required Function() onTap}) {
        final isHover = Rx(false);
        final isTapping = Rx(false);
        final textWidget = Text(text, style: const TextStyle(color: Colors.white, fontFamily: textFontFamily, fontSize: 18, fontWeight: FontWeight.bold));
        return InkWell(
          onHover: (value) => isHover.value = value,
          onTapDown: (_) => isTapping.value = true,
          onTapCancel: () => isTapping.value = false,
          onTap: onTap,
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              width: 255,
              height: 70,
              foregroundDecoration: BoxDecoration(
                gradient: isHover.value && !isTapping.value ? null : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0, 0.5], colors: [Colors.black.withOpacity(0.5), Colors.transparent]),
              ),
              decoration: BoxDecoration(
                color: isTapping.value ? const Color.fromRGBO(63, 75, 81, 1) : const Color.fromRGBO(67, 75, 82, 1),
                border: Border.all(color: const Color.fromRGBO(104, 104, 104, 1), width: 1),
              ),
              child: textWidget,
            ),
          ),
        );
      }

      //widget
      final titleWidget = Text(title, style: const TextStyle(color: Color.fromRGBO(176, 181, 181, 1), fontFamily: textFontFamily, fontSize: 24));
      final detailWidget = Text(detail, style: const TextStyle(color: Colors.white, fontFamily: textFontFamily, fontSize: 20));
      final yesButtonWidget = buttonBuilder(text: yesText, onTap: () => Navigator.pop(context, true));
      final noButtonWidget = buttonBuilder(text: noText, onTap: () => Navigator.pop(context, false));

      return ScaleTransition(
        scale: curvedAnimation,
        child: Center(
          child: Material(
            //Fix error when InkWell is not inside Material
            child: Container(
              alignment: Alignment.center,
              width: 730,
              height: 375,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(33, 39, 40, 1),
                border: Border.all(color: const Color.fromRGBO(95, 105, 106, 1), width: 1),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  titleWidget,
                  const SizedBox(height: 50),
                  detailWidget,
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      yesButtonWidget,
                      const SizedBox(width: 20),
                      noButtonWidget,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
