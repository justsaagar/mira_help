import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:visitor/app/constant/asset_constant.dart';
import 'package:visitor/app/constant/color_constant.dart';
import 'package:visitor/app/widgets/visitor_image_assets.dart';
import 'package:visitor/app/widgets/visitor_text.dart';

class VisitorTextFormField extends StatelessWidget {
  final String prefixIcon;
  final Widget? prefixWidget;
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? length;
  final String errorText;

  const VisitorTextFormField({
    Key? key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.prefixWidget,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.keyboardType = TextInputType.name,
    this.maxLines,
    this.length,
    this.errorText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50.px,
            padding: EdgeInsets.symmetric(horizontal: 10.px),
            decoration: BoxDecoration(
              color: VisitorColorConstants.appWhite,
              borderRadius: BorderRadius.circular(10.px),
              boxShadow: VisitorColorConstants.appBoxShadow,
            ),
            child: Row(
              children: [
                prefixIcon.isEmpty
                    ? prefixWidget!
                    : VisitorImageAsset(image: prefixIcon, height: 30.px, width: 20.px, color: VisitorColorConstants.appGrey),
                SizedBox(width: 10.px),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    maxLines: maxLines,
                    onChanged: onChanged,
                    style: TextStyle(
                      fontFamily: VisitorAssets.defaultFont,
                      color: VisitorColorConstants.appBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.px,
                    ),
                    inputFormatters: [
                      if(length != null) LengthLimitingTextInputFormatter(length),
                    ],
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      hintText: hintText.tr,
                      hintStyle: TextStyle(
                        fontFamily: VisitorAssets.defaultFont,
                        color: VisitorColorConstants.appGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.px,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (errorText.isNotEmpty) ...[
          SizedBox(height: 4.px),
          VisitorText(errorText, color: VisitorColorConstants.appTomatoRed)
        ],
      ],
    );
  }
}
