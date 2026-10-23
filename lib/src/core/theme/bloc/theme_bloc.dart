import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/local_storage/local_storage_key.dart';
import 'package:tickly/src/core/theme/model/theme_model.dart';




part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppThemeState> {
  ThemeBloc() : super(AppThemeState()) {
    on<ChangeTheme>(onChangeTheme);
    on<GetTheme>(onGetTheme);
  }

  Future<void> onChangeTheme(
    ChangeTheme event,
    Emitter<AppThemeState> emit,
  ) async {
    AppLocalStorage.update(
      LocalStorageKey.themePrefs,
      event.selectedTheme.value.toString(),
    );
    emit(state.copyWith(selectedTheme: event.selectedTheme));
  }

  Future<void> onGetTheme(GetTheme event, Emitter<AppThemeState> emit) async {
    final themeCode = AppLocalStorage.get(LocalStorageKey.themePrefs);
    emit(
      state.copyWith(
        selectedTheme: themeCode != null
            ? ThemeModel.values.firstWhere(
                (item) => item.value.toString() == themeCode,
                orElse: () => _selectedDefaultTheme(),
              )
            : _selectedDefaultTheme(),
      ),
    );
  }

  ThemeModel _selectedDefaultTheme() {
    ThemeModel theme = ThemeModel.system;
    AppLocalStorage.update(LocalStorageKey.themePrefs, theme.value.toString());
    return theme;
  }
}
