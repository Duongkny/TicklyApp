
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/core/injections/injections.dart';
import 'package:tickly/src/features/categories/domain/entities/category_entity.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_event.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_state.dart';
import 'package:tickly/src/features/categories/presentation/widgets/category_badge.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_information.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  final String taskId;

  // ==================== DELETE TASK ====================

  Future<void> _confirmDelete(BuildContext context) async {
    final taskBloc = context.read<TaskBloc>();

    if (taskBloc.state.actionStatus ==
        TaskActionStatus.loading) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa công việc?'),
        content: const Text(
          'Bạn có chắc muốn xóa công việc này?\n\n'
          'Công việc sẽ bị xóa vĩnh viễn.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete != true ||
        !context.mounted ||
        taskBloc.isClosed) {
      return;
    }

    taskBloc.add(TaskDeleteRequested(taskId));
  }

  // ==================== EDIT TASK ====================

  void _openEditTask(
    BuildContext context,
    TaskEntity task,
  ) {
    final taskBloc = context.read<TaskBloc>();

    if (taskBloc.state.actionStatus ==
        TaskActionStatus.loading) {
      return;
    }

    // Xóa trạng thái action cũ.
    taskBloc.add(const TaskActionCleared());

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            // Dùng lại TaskBloc.
            BlocProvider<TaskBloc>.value(
              value: taskBloc,
            ),

            // Giữ cách tạo CategoryBloc riêng
            // đã hoạt động với EditTaskScreen.
            BlocProvider<CategoryBloc>(
              create: (_) => getIt<CategoryBloc>()
                ..add(const CategoryStarted()),
            ),
          ],
          child: EditTaskScreen(task: task),
        ),
      ),
    );
  }

  // ==================== TOGGLE TASK ====================

  void _toggleTask(
    BuildContext context,
    bool isCompleted,
  ) {
    context.read<TaskBloc>().add(
      TaskToggleRequested(
        taskId: taskId,
        isCompleted: isCompleted,
      ),
    );
  }

  // ==================== CATEGORY SECTION ====================

  Widget _buildCategorySection(
    BuildContext context,
    TaskEntity task,
  ) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        CategoryEntity? selectedCategory;

        for (final category in categoryState.categories) {
          if (category.id == task.categoryId) {
            selectedCategory = category;
            break;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh mục',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            if (selectedCategory != null)
              CategoryBadge(
                category: selectedCategory,
              )
            else if (categoryState.status ==
                    CategoryViewStatus.loading ||
                categoryState.status ==
                    CategoryViewStatus.initial)
              const Text('Đang tải danh mục...')
            else
              Text(
                task.categoryId == null
                    ? 'Chưa phân loại'
                    : 'Không tìm thấy danh mục',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                ),
              ),
          ],
        );
      },
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) {
        return previous.actionStatus !=
                current.actionStatus ||
            previous.action != current.action;
      },
      listener: (context, state) {
        // Xóa thành công.
        if (state.action == TaskAction.delete &&
            state.actionStatus ==
                TaskActionStatus.success) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }

        // Xóa thất bại.
        if (state.action == TaskAction.delete &&
            state.actionStatus ==
                TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    'Không thể xóa công việc',
              ),
            ),
          );
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // ==================== FIND TASK ====================

          TaskEntity? task;

          for (final item in state.tasks) {
            if (item.id == taskId) {
              task = item;
              break;
            }
          }

          if (task == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Chi tiết công việc'),
              ),
              body: const Center(
                child: Text('Không tìm thấy công việc'),
              ),
            );
          }

          final currentTask = task;

          final isLoading =
              state.actionStatus ==
              TaskActionStatus.loading;

          // ==================== SCAFFOLD ====================

          return Scaffold(
            backgroundColor: colors.surface,

            // ==================== APP BAR ====================

            appBar: AppBar(
              title: const Text('Chi tiết công việc'),
              backgroundColor: colors.surface,
              actions: [
                IconButton(
                  tooltip: 'Chỉnh sửa',
                  onPressed: isLoading
                      ? null
                      : () => _openEditTask(
                          context,
                          currentTask,
                        ),
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'Xóa',
                  onPressed: isLoading
                      ? null
                      : () => _confirmDelete(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: colors.error,
                  ),
                ),
              ],
            ),

            // ==================== BODY ====================

            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ==================== TITLE ====================

                Text(
                  currentTask.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 16),

                // ==================== STATUS ====================

                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(
                      currentTask.isCompleted
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: currentTask.isCompleted
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                    label: Text(
                      currentTask.isCompleted
                          ? 'Đã hoàn thành'
                          : 'Chưa hoàn thành',
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== DESCRIPTION ====================

                Text(
                  'Mô tả',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  currentTask.description?.trim().isNotEmpty ==
                          true
                      ? currentTask.description!
                      : 'Chưa có mô tả',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),

                // ==================== CATEGORY ====================

                _buildCategorySection(
                  context,
                  currentTask,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),

                // ==================== TASK INFORMATION ====================

                TaskInformation(
                  task: currentTask,
                ),

                const SizedBox(height: 24),
                const Divider(),

                // ==================== COMPLETE SWITCH ====================

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Đánh dấu hoàn thành',
                  ),
                  subtitle: Text(
                    currentTask.isCompleted
                        ? 'Công việc đã hoàn thành'
                        : 'Công việc chưa hoàn thành',
                  ),
                  value: currentTask.isCompleted,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          _toggleTask(context, value);
                        },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
