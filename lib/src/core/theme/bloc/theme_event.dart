part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  const ChangeTheme({required this.selectedTheme});
  final ThemeModel selectedTheme;

  @override
  List<Object> get props => [selectedTheme];
}

class GetTheme extends ThemeEvent {}
