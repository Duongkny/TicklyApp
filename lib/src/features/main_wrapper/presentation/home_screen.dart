import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/core/injections/injections.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_event.dart';
import 'package:tickly/src/features/categories/presentation/screens/category_screen.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_event.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';
import 'package:tickly/src/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:tickly/src/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ==================== CREATE TASK ====================

  void _openCreateTask(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();

    // Xóa trạng thái thao tác trước đó
    taskBloc.add(const TaskActionCleared());

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: taskBloc,
          child: const CreateTaskScreen(),
        ),
      ),
    );
  }

  // ==================== TASK DETAIL ====================

  void _openTaskDetail(BuildContext context, String taskId) {
    final taskBloc = context.read<TaskBloc>();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: taskBloc,
          child: TaskDetailScreen(taskId: taskId),
        ),
      ),
    );
  }

  // ==================== TOGGLE TASK ====================

  void _toggleTask(
    BuildContext context, {
    required String taskId,
    required bool isCompleted,
  }) {
    context.read<TaskBloc>().add(
      TaskToggleRequested(taskId: taskId, isCompleted: isCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ==================== APP BAR ====================
  
appBar: AppBar(
  title: const Text('My Tasks'),
  centerTitle: false,
  backgroundColor: colorScheme.surface,
  elevation: 0,
  actions: [
    IconButton(
      tooltip: 'Danh mục',
      icon: const Icon(Icons.folder_outlined),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider<CategoryBloc>(
              create: (_) => getIt<CategoryBloc>()
                ..add(const CategoryStarted()),
              child: const CategoryScreen(),
            ),
          ),
        );
      },
    ),
  ],
),

      // ==================== BODY ====================
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // ==================== LOADING ====================

          if (state.status == TaskStatusView.initial ||
              state.status == TaskStatusView.loading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          // ==================== ERROR ====================

          if (state.status == TaskStatusView.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không thể tải danh sách công việc',
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Đã xảy ra lỗi. Vui lòng thử lại.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<TaskBloc>().add(const TaskStarted());
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ==================== EMPTY STATE ====================

          if (state.tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Chưa có công việc nào',
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy thêm công việc đầu tiên của bạn!',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _openCreateTask(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tạo công việc'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ==================== TASK LIST ====================

          return Column(
            children: [
              // ==================== PROGRESS ====================
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: colorScheme.primaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tiến độ công việc',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(state.completionProgress * 100).round()}%',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${state.completedCount}/${state.totalTasks} đã hoàn thành',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: state.completionProgress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: colorScheme.surface,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ==================== TASK COUNT ====================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách công việc',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${state.totalTasks} công việc',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================== TASK ITEMS ====================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];

                    final isLoading =
                        state.actionStatus == TaskActionStatus.loading;

                    return TaskCard(
                      task: task,
                      enabled: state.actionStatus != TaskActionStatus.loading,
                      onTap: () => _openTaskDetail(context, task.id),
                      onToggle: (value) {
                        _toggleTask(
                          context,
                          taskId: task.id,
                          isCompleted: value,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // ==================== ADD TASK BUTTON ====================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateTask(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm công việc'),
      ),
    );
  }
}
