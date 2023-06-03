import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramsun/controller/login_with_user_name_controller.dart';
import 'package:ramsun/pages/auth/login/login.dart';
import 'package:ramsun/routes/route_helper.dart';
import 'package:ramsun/services/rest_service.dart';
import 'package:ramsun/utils/shared_pref.dart';
import 'package:ramsun/utils/validation_utils.dart';

class LoginWithUserNameViewModel {
  RxBool isLoading = false.obs;
  RxBool isPasswordHide = true.obs;
  RxString userNameErrorMessage = ''.obs;
  RxString passwordErrorMessage = ''.obs;
  late LoginWithUserNameState loginWithUserNameState;
  late LoginWithUserNameController loginWithUserNameController;
  final TextEditingController userNameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  LoginWithUserNameViewModel(this.loginWithUserNameState);

  void onTapShowPassword() {
    isPasswordHide.value = !isPasswordHide.value;
    loginWithUserNameController.update();
  }

  Future<void> onTapLogin() async {
    FocusScope.of(Get.context!).unfocus();

    if (ValidationUtils.validateEmptyController(userNameTextController)) {
      userNameErrorMessage = 'emptyUsername'.tr.obs;
    } else {
      userNameErrorMessage = ''.obs;
    }

    if (ValidationUtils.validateEmptyController(passwordTextController)) {
      passwordErrorMessage = 'emptyPassword'.tr.obs;
    } else {
      passwordErrorMessage = ''.obs;
    }

    loginWithUserNameController.update();

    if (userNameErrorMessage.isEmpty && passwordErrorMessage.isEmpty) {
      isLoading = true.obs;

      Map<String, dynamic> bodyParams = {
        'user_email': userNameTextController.text,
        'user_password':  passwordTextController.text,
      };

      String? response = await loginWithUserNameController.loginWithUserName(bodyParams);

      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> res = jsonDecode(response);

        if (res['responseCode'] == 200) {
          await setPrefBoolValue(isLoggedIn, true);
          await setPrefBoolValue(isVerify, true);
          await setPrefStringValue(token, 'Bearer ${res['data']['token']}');
          RestServices.instance.headers['Authorization'] = 'Bearer ${res['data']['token']}';
          Get.offAllNamed(RouteHelper.getDashboardRoute());
        } else {
          res['responseMessage'].showError();
        }
      }
      isLoading = false.obs;
      loginWithUserNameController.update();
    }
  }
}
