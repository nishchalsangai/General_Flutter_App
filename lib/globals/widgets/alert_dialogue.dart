import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

onProcessCompletion(BuildContext context, String title, String content, bool? state) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(title,
          style: GoogleFonts.openSans(
              fontSize: 16, color: AppTheme.headingColor, fontWeight: FontWeight.w600)),
      content: Text(
        content,
        style: GoogleFonts.openSans(
            fontSize: 12, color: AppTheme.headingColor, fontWeight: FontWeight.w500),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              state == true
                  ? Navigator.of(context).popUntil((route) => route.isFirst)
                  : Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              primary: AppTheme.primaryColor,
              shadowColor: AppTheme.subHeadingColor.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            child: Center(
              child: Text("Ok, Thank you",
                  style: GoogleFonts.openSans(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    ),
  );
}
