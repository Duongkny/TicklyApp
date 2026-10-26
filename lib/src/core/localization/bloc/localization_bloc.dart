import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/local_storage/local_storage_key.dart';
import 'localization_event.dart';
import 'localization_state.dart';
import '../model/language.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc({
    String? Function()? readLanguage,
    Future<void> Function(String)? saveLanguage,
  }) : _readLanguage = readLanguage ?? _readSavedLanguage,
       _saveLanguage = saveLanguage ?? _saveSelectedLanguage,
       super(const LocalizationState()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<GetLanguage>(_onGetLanguage);
  }
  final String? Function() _readLanguage;
  final Future<void> Function(String) _saveLanguage;
  static String? _readSavedLanguage() {
    final value = AppLocalStorage.get(LocalStorageKey.languageKey);
    return value is String ? value : null;
  }

  static Future<void> _saveSelectedLanguage(String code) =>
      AppLocalStorage.localBox.put(LocalStorageKey.languageKey, code);

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LocalizationState> emit,
  ) async {
    await _saveLanguage(event.selectedLanguage.value.languageCode);
    AppLocalStorage.currentLanguageCode =
        event.selectedLanguage.value.languageCode;
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  void _onGetLanguage(GetLanguage event, Emitter<LocalizationState> emit) {
    final code = _readLanguage();
    final language = Language.values.firstWhere(
      (item) => item.value.languageCode == code,
      orElse: () => Language.vi,
    );
    AppLocalStorage.currentLanguageCode = language.value.languageCode;
    emit(state.copyWith(selectedLanguage: language));
  }
}
