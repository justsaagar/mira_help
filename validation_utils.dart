import 'package:flutter/material.dart';

class ValidationUtils {

  //     ======================= Regular Expressions =======================     //
  static const String phoneRegExp = r'^[+]?[(]?[0-9]{3}[)]?[-s.]?[0-9]{3}[-s.]?[0-9]{4,6}$';
  static const String emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String nameRegExp = r'^[a-zA-Z ]+$';
  static const String passwordRegexp = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$";
  static const String panCardRegexp = r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$";
  static const String gstNumberRegexp = r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$";
  static const String aadhaarNumberRegexp = r"^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$";
  static const String  formatAmountRegExp = r'(\d{1,3})(?=(\d{3})+(?!\d))';



  //     ======================= Validation methods =======================     //
  static bool validateEmptyController(TextEditingController textEditingController) {
    return textEditingController.text.trim().isEmpty;
  }

  static bool lengthValidator(TextEditingController textEditingController, int length) {
    return textEditingController.text.trim().length < length;
  }

  static bool regexValidator(TextEditingController textEditingController, String regex) {
    return RegExp(regex).hasMatch(textEditingController.text);
  }

  static bool compareValidator(TextEditingController textEditingController, TextEditingController secondController) {
    return textEditingController.text != secondController.text;
  }
}