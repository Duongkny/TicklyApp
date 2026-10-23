import 'package:flutter/material.dart';
import 'package:tickly/src/core/extensions/string.dart';

abstract class Validators {
  Validators._();

  static FormFieldValidator<String>? getValidator(TextInputType? keyboardType) {
    return switch (keyboardType) {
      TextInputType.name => Validators.name,
      TextInputType.emailAddress => Validators.email,
      TextInputType.number => Validators.number,
      TextInputType.phone => Validators.number,
      _ => null,
    };
  }

  static String? required(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return "navigatorKey.currentContext?.loc.required";
    }

    return null;
  }

  static String? requiredTyped<T>(T? input) {
    if (input == null) {
      return "navigatorKey.currentContext?.loc.required";
    }

    return null;
  }

  static String? name(String? name) {
    if (name == null || name.isEmpty) {
      return "navigatorKey.currentContext?.loc.required";
    }
    return null;
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return "navigatorKey.currentContext?.loc.required";
    }

    if (!email.isValidEmail()) {
      return "navigatorKey.currentContext?.loc.enter_valid_email";
    }

    return null;
  }

  static String? otp(String? code) {
    if (code == null || code.isEmpty) {
      return "navigatorKey.currentContext?.loc.required";
    }

    if (code.length != 6) {
      return "navigatorKey.currentContext?.loc.required";
    }

    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return "navigatorKey.currentContext?.loc.required";
    }

    if (password.length < 8) {
      return "navigatorKey.currentContext?.loc.password_must_be_at_least(8)";
    }

    // if (!password.contains(RegExp('[A-Z]'))) {
    //   return "navigatorKey.currentContext?.loc
    //       .password_must_contain_at_least_one_capital_letter";
    // }

    return null;
  }

  static String? number(String? input) {
    if (input == null) {
      return "navigatorKey.currentContext?.loc.required";
    }

    final number = num.tryParse(input);
    if (number == null) {
      return "navigatorKey.currentContext?.loc.enter_valid_number";
    }

    return null;
  }

  static String? positiveInteger(String? input) {
    if (input == null) {
      return "navigatorKey.currentContext?.loc.required";
    }

    final integer = int.tryParse(input);
    if (integer == null || integer <= 0) {
      return "navigatorKey.currentContext?.loc.enter_positive_integer";
    }

    return null;
  }
}