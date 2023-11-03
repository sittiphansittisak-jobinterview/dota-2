import 'package:dota_2_client_flutter/config/font_family_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showWidgetDialog({required BuildContext context, required Widget child}) async {
  return await showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      //animation
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      //widget property
      const textFontFamily = FontFamilyStyle.mainThai;

      return ScaleTransition(
        scale: curvedAnimation,
        child: child,
      );
    },
  );
}
