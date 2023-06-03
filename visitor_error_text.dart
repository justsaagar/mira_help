import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:visitor/app/constant/color_constant.dart';
import 'package:visitor/app/widgets/visitor_text.dart';

class VisitorErrorText extends StatelessWidget {
  final String errorText;

  const VisitorErrorText({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.px),
      child: VisitorText(
        errorText,
        color: VisitorColorConstants.appTomatoRed,
        fontSize: 14.px,
        fontWeight: FontWeight.w400,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
