import 'package:flutter/material.dart';
import 'package:tickly/src/core/extensions/string.dart';
import '../localization/app_strings.dart';

abstract final class Validators {
  static FormFieldValidator<String>? getValidator(TextInputType? type) =>
      switch (type) {
        TextInputType.name => name,
        TextInputType.emailAddress => email,
        TextInputType.number || TextInputType.phone => number,
        _ => null,
      };
  static String? required(String? value) =>
      value == null || value.trim().isEmpty
      ? AppStrings.current.validationRequired
      : null;
  static String? requiredTyped<T>(T? value) =>
      value == null ? AppStrings.current.validationRequired : null;
  static String? name(String? value) => value == null || value.trim().isEmpty
      ? AppStrings.current.validationNameRequired
      : null;
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.validationEmailRequired;
    }
    return value.trim().isValidEmail()
        ? null
        : AppStrings.current.validationEmailInvalid;
  }

  static String? otp(String? value) =>
      value != null && RegExp(r'^\d{6}$').hasMatch(value)
      ? null
      : AppStrings.current.validationOtp;
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.current.validationPasswordRequired;
    }
    return value.length >= 8
        ? null
        : AppStrings.current.validationPasswordMinLength;
  }

  static String? number(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.validationRequired;
    }
    return num.tryParse(value) != null
        ? null
        : AppStrings.current.validationNumberInvalid;
  }

  static String? positiveInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.validationRequired;
    }
    final parsed = int.tryParse(value);
    return parsed != null && parsed > 0
        ? null
        : AppStrings.current.validationPositiveInteger;
  }
}
