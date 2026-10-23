import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/output/app_localization.dart';
import '../app/providers/user_provider.dart';

extension Context on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  AppLocalizations get loc => AppLocalizations.of(this);

  void closeKeyboard() => FocusScope.of(this).unfocus();

  void showSnackBarMessage(String message, {bool isError = false}) {
    final theme = Theme.of(this);
    final Color? foregroundColor;
    final Color? backgroundColor;
    if (isError) {
      foregroundColor = theme.colorScheme.onError;
      backgroundColor = theme.colorScheme.error;
    } else {
      foregroundColor = null;
      backgroundColor = null;
    }

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message, style: TextStyle(color: foregroundColor)),
      ),
    );
  }
}