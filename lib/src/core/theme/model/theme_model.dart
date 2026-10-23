import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
// import '../../gen/assets.gen.dart';

enum ThemeModel {
  system(
    ThemeMode.system,
  ),
  light(
    ThemeMode.light,
  ),
  dark(
    ThemeMode.dark,
  );

  const ThemeModel(this.value);

  final ThemeMode value;
}
