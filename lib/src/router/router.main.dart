import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_state.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:tickly/src/core/injections/injections.dart';
import 'package:tickly/src/core/notification/task_reminder_service.dart';

// HomeScreen
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';

// TaskBloc
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_event.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';

// CategoryBloc
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_event.dart';

// Routes
import 'package:tickly/src/router/route.dart';

List<RouteBase> mainRoutes() => [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          // ==================== TASK BLOC ====================
          BlocProvider<TaskBloc>(
            create: (_) => getIt<TaskBloc>()..add(const TaskStarted()),
          ),

          // ==================== CATEGORY BLOC ====================
          BlocProvider<CategoryBloc>(
            create: (_) => getIt<CategoryBloc>()..add(const CategoryStarted()),
          ),
        ],

        // ==================== REMINDER LISTENER ====================
        child: BlocListener<TaskBloc, TaskState>(
          listenWhen: (previous, current) {
            return current.status == TaskStatusView.success &&
                !identical(previous.tasks, current.tasks);
          },
          listener: (context, taskState) async {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              return;
            }

            try {
              await TaskReminderService.instance.syncReminders(
                taskState.tasks,
                user.uid,
              );

              debugPrint('[Reminder] Đồng bộ lịch nhắc thành công');
            } catch (error, stackTrace) {
              debugPrint('[Reminder] Đồng bộ thất bại: $error');

              debugPrintStack(stackTrace: stackTrace);
            }
          },

          // ==================== HOME ====================
          child: BlocListener<LocalizationBloc, LocalizationState>(
            listenWhen: (previous, current) =>
                previous.selectedLanguage != current.selectedLanguage,
            listener: (context, language) async {
              final user = FirebaseAuth.instance.currentUser;
              final tasks = context.read<TaskBloc>().state;
              if (user == null || tasks.status != TaskStatusView.success) {
                return;
              }
              try {
                await TaskReminderService.instance.syncReminders(
                  tasks.tasks,
                  user.uid,
                );
              } catch (error) {
                debugPrint(
                  '[Reminder] Could not update reminder language: $error',
                );
              }
            },
            child: const HomeScreen(),
          ),
        ),
      );
    },
  ),

  // GoRoute(
  //   path: AppRoute.settings,
  //   builder: (context, state) => const SettingsScreen(),
  // ),
];
