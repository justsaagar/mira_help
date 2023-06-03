import 'package:fleet_track/app/widget/app_text.dart';
import 'package:fleet_track/constant/color_constant.dart';
import 'package:fleet_track/generated/l10n.dart';
import 'package:fleet_track/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContinueOptions extends StatelessWidget {
  const ContinueOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          children: [
            Expanded(child: Container(height: 1, decoration: BoxDecoration(color: ColorConstant.appBlack))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppText(
                text: S.of(context).dontHaveAccount,
                textStyle: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorConstant.appBlack,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, decoration: BoxDecoration(color: ColorConstant.appBlack))),
          ],
        );
      },
    );
  }
}
