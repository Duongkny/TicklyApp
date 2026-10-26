import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tickly/l10n/output/app_localization.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/local_storage/local_storage_key.dart';
import 'package:tickly/src/core/localization/app_strings.dart';
import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_event.dart';
import 'package:tickly/src/core/localization/bloc/localization_state.dart';
import 'package:tickly/src/core/localization/model/language.dart';
import 'package:tickly/src/core/localization/ui/widget/language_selector_tile.dart';
import 'package:tickly/src/core/utils/validators.dart';

void main() {
  late Directory directory;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('tickly-l10n-test-');
    Hive.init(directory.path);
    await Hive.openBox(LocalStorageKey.localStorage);
  });
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });
  setUp(() async {
    await AppLocalStorage.localBox.clear();
    AppLocalStorage.currentLanguageCode = 'vi';
  });
  test(
    'English has every Vietnamese key and supports plurals and placeholders',
    () {
      final vi =
          jsonDecode(File('lib/l10n/app_vi.arb').readAsStringSync())
              as Map<String, dynamic>;
      final en =
          jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
              as Map<String, dynamic>;
      expect(
        en.keys.where((key) => !key.startsWith('@')).toSet(),
        vi.keys.where((key) => !key.startsWith('@')).toSet(),
      );
      final strings = lookupAppLocalizations(const Locale('en'));
      expect(strings.taskCount(1), '1 task');
      expect(strings.taskCount(2), '2 tasks');
      expect(strings.taskCount(0), '0 tasks');
      expect(
        strings.categoryDeleteConfirmation('My category'),
        contains('My category'),
      );
      expect(strings.resetPasswordConfirmation('a@b.com'), contains('a@b.com'));
      expect(strings.reminderBody('Học bài'), 'Time for: Học bài');
    },
  );
  test(
    'Saved language and non-widget messages are restored at startup',
    () async {
      await AppLocalStorage.localBox.put(LocalStorageKey.languageKey, 'en');
      final bloc = LocalizationBloc();
      final restored = bloc.stream.firstWhere(
        (state) => state.selectedLanguage == Language.en,
      );
      bloc.add(GetLanguage());
      await restored;
      expect(AppStrings.current.taskReminders, 'Task reminders');
      expect(Validators.email(''), 'Please enter your email');
      expect(
        Validators.password('123'),
        'Password must contain at least 8 characters',
      );
      expect(Validators.otp('abcdef'), 'Please enter a 6-digit code');
      final changed = bloc.stream.firstWhere(
        (state) => state.selectedLanguage == Language.vi,
      );
      bloc.add(const ChangeLanguage(selectedLanguage: Language.vi));
      await changed;
      expect(AppLocalStorage.get(LocalStorageKey.languageKey), 'vi');
      await bloc.close();
    },
  );
  testWidgets(
    'Settings changes language live and saves it for the next launch',
    (tester) async {
      String? savedLanguage;
      final bloc = LocalizationBloc(
        readLanguage: () => savedLanguage,
        saveLanguage: (code) async {
          savedLanguage = code;
        },
      );
      addTearDown(bloc.close);
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: BlocBuilder<LocalizationBloc, LocalizationState>(
            builder: (context, state) => MaterialApp(
              locale: state.selectedLanguage.value,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const Scaffold(body: LanguageSelectorTile()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(bloc.state.selectedLanguage, Language.en);
      await tester.pumpAndSettle();
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(savedLanguage, 'en');
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tiếng Việt'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(bloc.state.selectedLanguage, Language.vi);
      await tester.pumpAndSettle();
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(Validators.email(''), 'Vui lòng nhập email');
    },
  );
}
