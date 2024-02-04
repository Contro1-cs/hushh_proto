import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';

socialButton(String icon, String title, Function() onPressed) {
  return Expanded(
    child: IconButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallet.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: SvgPicture.asset(
        icon,
        height: 30,
      ),
    ),
  );
}
