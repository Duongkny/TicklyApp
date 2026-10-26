import 'dart:ui';

enum Language {
  vi(Locale('vi'), 'Tiếng Việt'),
  en(Locale('en'), 'English');

  const Language(this.value, this.text);
  final Locale value;
  final String text;
}
