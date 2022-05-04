import 'package:flutter/material.dart';

class ValidateMixin {
  String? usernameValidator(value) {
    if (value!.length < 4) {
      return 'Enter at least 4 characters';
    } else if (value.length > 30) {
      return 'Enter at most 30 characters';
    } else {
      return null;
    }
  }

  String? emailValidator(value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Enter an email';
    } else if (!regExp.hasMatch(value.toString().trim())) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? passwordValidator(value) {
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Enter Password';
    } else if (!regExp.hasMatch(value.toString().trim())) {
      return 'Password should contain:\n1)at least one capital letter\n2)at least one small letter\n3)at least one special character\n4)minimum length should be 8';
    } else {
      return null;
    }
  }
}
