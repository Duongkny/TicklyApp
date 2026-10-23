import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/local_storage/local_storage_key.dart';
import 'package:tickly/src/core/localization/bloc/localization_event.dart';
import 'package:tickly/src/core/localization/bloc/localization_state.dart';
import 'package:tickly/src/core/localization/model/language.dart';

const languagePrefsKey = 'languagePrefs';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState()) {
   on<ChangeLanguage>(onChangeLanguage);
    on<GetLanguage>(onGetLanguage);
  }

  Future<void> onChangeLanguage(
    ChangeLanguage event, 
    Emitter<LocalizationState> emit
    ) async {
      AppLocalStorage.update(
        LocalStorageKey.languageKey,
        event.selectedLanguage.value.languageCode,
      );

    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
    AppLocalStorage.currentLanguageCode = AppLocalStorage.get(
      LocalStorageKey.languageKey,
    );
  }

  Future<void> onGetLanguage(GetLanguage event, Emitter<LocalizationState> emit) async {
    // Handle the event to get the current language
    final languageCode = AppLocalStorage.get(LocalStorageKey.languageKey);
    emit(
      state.copyWith(
        selectedLanguage: languageCode != null
            ? Language.values.firstWhere(
              (item) => item.value.languageCode == languageCode,
              orElse: () => _selectedDefaultLanguage(),
            )
            : Language.vi, // Default to Vietnamese if not set
      ),
    );
  }

  Language _selectedDefaultLanguage() {
    // Return a default language based on the provided language code
    Language language = Language.values.firstWhere(
      (item) => item.value.languageCode == AppLocalStorage.currentLanguageCode,
      orElse: () => Language.vi, // Default to Vietnamese if not found
    );
    AppLocalStorage.update(
      LocalStorageKey.languageKey,
      language.value.languageCode,
    );
    return language;
  }
}