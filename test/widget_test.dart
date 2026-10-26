import 'package:tickly/l10n/output/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tickly/src/constants/app_theme.dart';
import 'package:tickly/src/features/auth/presentation/screens/auth_screen.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tickly/src/features/tasks/presentation/utils/task_period.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_card.dart';
import 'package:tickly/src/features/statistics/presentation/widgets/category_statistics.dart';
import 'package:tickly/src/features/statistics/domain/usecases/calculate_statistics_usecase.dart';

TaskEntity task({
  DateTime? due,
  TaskStatus status = TaskStatus.pending,
  DateTime? completed,
}) => TaskEntity(
  id: '1',
  userId: 'test',
  title: 'Học bài',
  dueDate: due,
  status: status,
  completedAt: completed,
  createdAt: DateTime(2026, 10, 26),
  updatedAt: DateTime(2026, 10, 26),
);
void main() {
  test(
    'Date filters use local day boundaries and retain undated tasks in All',
    () {
      final now = DateTime(2026, 10, 26, 12);
      expect(
        TaskPeriod.today.includes(task(due: DateTime(2026, 10, 26)), now),
        isTrue,
      );
      expect(
        TaskPeriod.today.includes(
          task(due: DateTime(2026, 10, 26, 23, 59)),
          now,
        ),
        isTrue,
      );
      expect(
        TaskPeriod.today.includes(task(due: DateTime(2026, 10, 27)), now),
        isFalse,
      );
      expect(
        TaskPeriod.upcoming.includes(task(due: DateTime(2026, 10, 27)), now),
        isTrue,
      );
      expect(
        TaskPeriod.upcoming.includes(task(due: DateTime(2026, 10, 25)), now),
        isFalse,
      );
      expect(TaskPeriod.today.includes(task(), now), isFalse);
      expect(TaskPeriod.all.includes(task(), now), isTrue);
    },
  );
  test('Statistics exclude completed overdue tasks and handle empty data', () {
    final now = DateTime(2026, 10, 26);
    final result = const CalculateStatistics()([
      task(due: now.subtract(const Duration(days: 1))),
      task(
        due: now.subtract(const Duration(days: 1)),
        status: TaskStatus.completed,
      ),
      task(),
    ], now: now);
    expect(result.totalTasks, 3);
    expect(result.completedTasks, 1);
    expect(result.overdueTasks, 1);
    expect(const CalculateStatistics()([]).completionRate, 0);
  });
  testWidgets('Welcome works on a small screen and opens registration', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(path: '/welcome', builder: (_, _) => const AuthScreen()),
        GoRoute(
          path: '/sign-up',
          builder: (_, _) => const Scaffold(body: Text('Trang đăng ký')),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (_, _) => const Scaffold(body: Text('Trang đăng nhập')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme(ThemeData().textTheme).light(),
        routerConfig: router,
      ),
    );
    expect(find.text('Tickly'), findsOneWidget);
    await tester.ensureVisible(find.text('Bắt đầu'));
    await tester.tap(find.text('Bắt đầu'));
    await tester.pumpAndSettle();
    expect(find.text('Trang đăng ký'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'Task checkbox reports completion and disabled state blocks changes',
    (tester) async {
      bool? completed;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: TaskCard(
              task: task(),
              onTap: () {},
              onToggle: (value) => completed = value,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      expect(completed, isTrue);
      completed = null;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: TaskCard(
              task: task(),
              enabled: false,
              onTap: () {},
              onToggle: (value) => completed = value,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      expect(completed, isNull);
    },
  );
  testWidgets('Category chart accounts for missing categories and empty data', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: CategoryStatistics(tasks: [task()], categories: const []),
        ),
      ),
    );
    expect(find.text('Chưa phân loại'), findsOneWidget);
    expect(find.text('1 (100.0%)'), findsOneWidget);
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: CategoryStatistics(tasks: [], categories: []),
        ),
      ),
    );
    expect(
      find.text('Thêm công việc để xem phân bố danh mục.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
