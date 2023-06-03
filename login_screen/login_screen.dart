import 'dart:io';
import 'package:fleet_track/app/app_logs.dart';
import 'package:fleet_track/app/widget/app_button.dart';
import 'package:fleet_track/app/widget/app_image_assets.dart';
import 'package:fleet_track/app/widget/app_loader.dart';
import 'package:fleet_track/app/widget/app_social_button.dart';
import 'package:fleet_track/app/widget/app_text.dart';
import 'package:fleet_track/app/widget/app_text_form_field.dart';
import 'package:fleet_track/app/widget/app_toast.dart';
import 'package:fleet_track/constant/app_asset.dart';
import 'package:fleet_track/constant/color_constant.dart';
import 'package:fleet_track/generated/l10n.dart';
import 'package:fleet_track/provider/login_screen_provider.dart';
import 'package:fleet_track/provider/theme_provider.dart';
import 'package:fleet_track/screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:fleet_track/screen/sign_up_screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  final bool fromSplash;
  const LoginScreen({Key? key, this.fromSplash = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Consumer<LogInScreenProvider>(
      builder: (context, logInScreenProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if (!fromSplash) {
              DateTime now = DateTime.now();
              if (logInScreenProvider.currentBackPressTime == null || now.difference(logInScreenProvider.currentBackPressTime!) > Duration(seconds: 2)) {
                logInScreenProvider.currentBackPressTime = now;
                S.of(context).exitMsg.showToast(isError: true, visualDensity: true);
                return Future.value(false);
              }
              return Future.value(true);
            } else {
              return true;
            }
          },
          child: Scaffold(
        body: Consumer<ThemeProvider>(
          builder: (context,themeProvider, child) {
            return SafeArea(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20.px),
                    margin: EdgeInsets.only(top: 50),
                    child: AppImageAsset(image: AppAsset.appLogo, webHeight: 70.px),
                  ),
                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   padding: EdgeInsets.only(top: 36.px, left: 10.px),
                  //   child: IconButton(
                  //     onPressed: () {
                  //       if (!fromSplash) {
                  //         showDialog(
                  //           barrierDismissible: false,
                  //           context: context,
                  //           builder: (context) {
                  //             return AppAlertDialog(
                  //               title: S.of(context).exit,
                  //               message: S.of(context).confirmExitHeader,
                  //               isAction: true,
                  //               onTap: () => SystemNavigator.pop(),
                  //             );
                  //           },
                  //         );
                  //       } else {
                  //         Navigator.of(context).pop();
                  //       }
                  //     },
                  //     color: themeProvider.isDarkMode ? ColorConstant.appWhite : ColorConstant.appRed,
                  //     icon: Icon(Icons.arrow_back_ios),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 150.px),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode ? ColorConstant.appBlack :ColorConstant.appWhite,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(30.px), topRight: Radius.circular(30.px)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     offset: const Offset(0, -2),
                      //     spreadRadius: 0.5,
                      //     color: !themeProvider.isDarkMode ? ColorConstant.appLightBlack : ColorConstant.appWhite,
                      //     blurRadius: 5,
                      //   ),
                      // ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 26.px).copyWith(top: 40.px),
                      primary: true,
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        // AppText(
                        //   text: S.of(context).userLogIn,
                        //   textStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        //     color: ColorConstant.appRed,
                        //     fontSize: 24,
                        //   ),
                        // ),
                        SizedBox(height: 16),
                        Consumer<LogInScreenProvider>(
                          builder: (context, provider, child) {
                            return AppTextFormFiled(
                              hintText: S.of(context).enterUsername,
                              controller: provider.userNameController,
                              prefixIcon: AppAsset.personIcon,
                              textInputType: TextInputType.emailAddress,
                              isError: provider.userNameError != null,
                              requiredDecoration: false,
                              height: 40,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer<LogInScreenProvider>(
                          builder: (context, provider, child) {
                            return AppTextFormFiled(
                              hintText: S.of(context).password,
                              controller: provider.passwordController,
                              showVisibility: true,
                              textInputType: TextInputType.visiblePassword,
                              visibility: provider.obscureText,
                              suffixTap: () => provider.changeVisibility(),
                              prefixIcon: AppAsset.padLockIcon,
                              isError: provider.passwordError != null,
                              requiredDecoration: false,
                              height: 40,
                            );
                          },
                        ),
                        SizedBox(height: 16.px),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                logInScreenProvider.emailController.clear();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPassword()),
                                );
                              },
                              child: AppText(
                                text: '${S.of(context).forgotPassword}?',
                                textAlign: TextAlign.end,
                                textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.px,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpScreen(fromSplash: true)),
                              ),
                              child: AppText(
                                text: S.of(context).register,
                                textAlign: TextAlign.end,
                                textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: ColorConstant.appRed,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.px,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.px),
                        Consumer<LogInScreenProvider>(
                          builder: (context, provider, child) {
                            return AppElevatedButton(
                              text: S.of(context).logIn,
                              fontSize: 15.px,
                              borderRadius: 10.px,
                              height: 38.px,
                              onTap: () => provider.validateUser(context),
                            );
                          },
                        ),
                        SizedBox(height: 30.px),
                        if (Platform.isAndroid) ...[
                          Consumer<LogInScreenProvider>(
                            builder: (context, provider, child) {
                              return AppSocialElevatedButton(
                                text: S.of(context).googleSignIn,
                                onTap: () => provider.continueWithGoogle(context),
                                fontSize: 15,
                                borderRadius: 10.px,
                                height: 38.px,
                              );
                            },
                          ),
                          SizedBox(height: 30.px),
                        ],
                        // ContinueOptions(),
                      ],
                    ),
                  ),
                  if (logInScreenProvider.isLoading) const AppLoader(),
                ],
              ),
            );
          },
        ),
      ),
    );
  },
);
  }
}