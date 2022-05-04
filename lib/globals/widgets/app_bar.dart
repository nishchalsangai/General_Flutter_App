import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomAppBar {
  static AppBar customAppBar(
      {required bool leadingIcon,
      required String title,
      required BuildContext context,
      required Color color,
      required List<Widget> action}) {
    return AppBar(
      backgroundColor: color,
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: leadingIcon,
      centerTitle: true,
      actions: action,
      leading: leadingIcon
          ? IconButton(
              splashRadius: 25,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppTheme.headingColor,
              ),
            )
          : null,
      title: Text(title,
          style: const TextStyle(
              fontSize: 18,
              letterSpacing: .15,
              fontWeight: FontWeight.w600,
              color: AppTheme.headingColor)),
    );
  }
}
