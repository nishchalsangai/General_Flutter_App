import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_mvp/globals/size_config.dart';

import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.widget,
      required this.productName,
      required this.productDescription,
      required this.price})
      : super(key: key);
  final Widget widget;
  final String productName;
  final String productDescription;
  final String price;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 20,
          spreadRadius: 10,
        ),
      ]),
      child: Row(
        children: [
          widget,
          SizedBox(width: SizeConfig.safeBlockHorizontal!* 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.openSans(
                      fontSize: 12, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                Text(price,
                    style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: AppTheme.subHeadingColor,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                Text(productDescription,
                    style: GoogleFonts.openSans(
                        fontSize: 12, color: AppTheme.headingColor, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
