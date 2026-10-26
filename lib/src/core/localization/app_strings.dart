import 'dart:ui';
import 'package:tickly/l10n/output/app_localization.dart';
import '../local_storage/app_local_storage.dart';

/// Localization for non-widget code (validation, BLoCs and notifications).
/// Widgets use context.loc so they rebuild when the locale changes.
abstract final class AppStrings {
  static AppLocalizations get current => lookupAppLocalizations(
    Locale(AppLocalStorage.currentLanguageCode == 'en' ? 'en' : 'vi'),
  );
}
