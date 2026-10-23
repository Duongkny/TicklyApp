
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tickly/l10n/output/app_localization.dart';
import 'package:tickly/src/constants/app_theme.dart';
import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_state.dart';
import 'package:tickly/src/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(ThemeData().textTheme);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LocalizationBloc, LocalizationState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Tickly',
              debugShowCheckedModeBanner: false,

              // Router
              routerConfig: AppRouter.router,

              // Localization
              locale: Locale(state.selectedLanguage.name),
              supportedLocales:
                  AppLocalizations.supportedLocales,
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,

              // Theme
              theme: appTheme.light(),
              darkTheme: appTheme.dark(),
              themeMode: ThemeMode.system,
            );
          },
        );
      },
    );
  }
}
