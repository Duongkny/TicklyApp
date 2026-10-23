part of 'theme_bloc.dart';

class AppThemeState extends Equatable {
  const AppThemeState({
    ThemeModel? selectedTheme,
  }) : selectedTheme = selectedTheme ?? ThemeModel.system;

  final ThemeModel selectedTheme;

  @override
  List<Object> get props => [selectedTheme];

  AppThemeState copyWith({ThemeModel? selectedTheme}) {
    return AppThemeState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}
