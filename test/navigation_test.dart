import 'package:tickly/l10n/output/app_localization.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickly/src/constants/app_theme.dart';
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:tickly/src/features/auth/domain/entities/app_user.dart';
import 'package:tickly/src/features/categories/domain/entities/category_entity.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_state.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';

class _Auth extends Fake implements AuthBloc {
  @override
  AuthState get state => const AuthState(
    status: AuthStatus.authenticated,
    user: AppUser(
      id: 'test',
      displayName: 'Nguyễn Văn Anh',
      isEmailVerified: true,
    ),
  );
  @override
  Stream<AuthState> get stream => const Stream.empty();
}

class _Tasks extends Fake implements TaskBloc {
  @override
  TaskState get state => TaskState(
    status: TaskStatusView.success,
    tasks: [
      for (var i = 0; i < 5; i++)
        TaskEntity(
          id: '$i',
          userId: 'test',
          title: [
            'Học bài',
            'Tập thể dục',
            'Đọc sách',
            'Làm báo cáo',
            'Mua đồ siêu thị',
          ][i],
          categoryId: i.isEven ? 'study' : 'work',
          status: i == 1 ? TaskStatus.completed : TaskStatus.pending,
          dueDate: DateTime.now().copyWith(hour: 20, minute: 0),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
    ],
  );
  @override
  Stream<TaskState> get stream => const Stream.empty();
}

class _Categories extends Fake implements CategoryBloc {
  @override
  CategoryState get state => CategoryState(
    status: CategoryViewStatus.success,
    categories: [
      CategoryEntity(
        id: 'study',
        userId: 'test',
        name: 'Học tập',
        colorValue: 0xFFB794EE,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryEntity(
        id: 'work',
        userId: 'test',
        name: 'Công việc',
        colorValue: 0xFF5E84F8,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
  );
  @override
  Stream<CategoryState> get stream => const Stream.empty();
}

void main() {
  for (final language in ['vi', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('Navigation $language ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final key = GlobalKey();
        final previewFont = Platform.environment['TICKLY_PREVIEW_FONT'];
        if (previewFont != null) {
          await tester.runAsync(() async {
            await ui.loadFontFromList(
              await File(previewFont).readAsBytes(),
              fontFamily: 'Preview',
            );
            final icons = Platform.environment['TICKLY_PREVIEW_ICONS'];
            if (icons != null) {
              await ui.loadFontFromList(
                await File(icons).readAsBytes(),
                fontFamily: 'MaterialIcons',
              );
            }
          });
        }
        final theme = AppTheme(
          previewFont == null
              ? ThemeData().textTheme
              : ThemeData().textTheme.apply(fontFamily: 'Preview'),
        );
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: _Auth()),
              BlocProvider<TaskBloc>.value(value: _Tasks()),
              BlocProvider<CategoryBloc>.value(value: _Categories()),
            ],
            child: MaterialApp(
              locale: Locale(language),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: dark ? theme.dark() : theme.light(),
              home: RepaintBoundary(key: key, child: const HomeScreen()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Tickly'), findsOneWidget);
        expect(tester.takeException(), isNull);
        // Optional visual artifact; normal test runs do not write outside the repo.
        final output = Platform.environment['TICKLY_PREVIEW_DIR'];
        if (output != null) {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory(output).create(recursive: true);
            await File(
              '$output/tickly-${dark ? 'dark' : 'light'}.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        await tester.tap(find.byType(NavigationDestination).at(2));
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'vi' ? 'Tổng quan công việc' : 'Task overview'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(NavigationDestination).at(1));
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'vi' ? 'Tất cả công việc' : 'All tasks'),
          findsOneWidget,
        );
        await tester.tap(find.text('Học tập'));
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'vi' ? '3 công việc' : '3 tasks'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
