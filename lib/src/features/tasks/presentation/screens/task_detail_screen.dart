import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Thấp';
      case TaskPriority.medium:
        return 'Trung bình';
      case TaskPriority.high:
        return 'Cao';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Chưa đặt hạn';

    final d = date.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(d.day)}/${two(d.month)}/${d.year} '
        '${two(d.hour)}:${two(d.minute)}';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa công việc?'),
        content: const Text('Công việc này sẽ bị xóa vĩnh viễn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    context.read<TaskBloc>().add(TaskDeleteRequested(taskId));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus ||
          previous.action != current.action,
      listener: (context, state) {
        if (state.action == TaskAction.delete &&
            state.actionStatus == TaskActionStatus.success) {
          Navigator.of(context).pop();
        }

        if (state.action == TaskAction.delete &&
            state.actionStatus == TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Không thể xóa công việc'),
            ),
          );
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          TaskEntity? task;

          for (final item in state.tasks) {
            if (item.id == taskId) {
              task = item;
              break;
            }
          }

          if (task == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Chi tiết công việc')),
              body: const Center(child: Text('Không tìm thấy công việc')),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Chi tiết công việc'),
              actions: [
                IconButton(
                  tooltip: 'Chỉnh sửa',
                  onPressed: () {
                    context.read<TaskBloc>().add(const TaskActionCleared());

                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider.value(
                          value: context.read<TaskBloc>(),
                          child: EditTaskScreen(task: task!),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Xóa',
                  onPressed: state.actionStatus == TaskActionStatus.loading
                      ? null
                      : () => _confirmDelete(context),
                  icon: Icon(Icons.delete_outline, color: colors.error),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Chip(
                  label: Text(
                    task.isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành',
                  ),
                ),
                const SizedBox(height: 20),
                Text('Mô tả', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(task.description ?? 'Chưa có mô tả'),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Mức độ ưu tiên'),
                  subtitle: Text(_priorityLabel(task.priority)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Hạn hoàn thành'),
                  subtitle: Text(_formatDate(task.dueDate)),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Đã hoàn thành'),
                  value: task.isCompleted,
                  onChanged: state.actionStatus == TaskActionStatus.loading
                      ? null
                      : (value) {
                          context.read<TaskBloc>().add(
                            TaskToggleRequested(
                              taskId: taskId,
                              isCompleted: value,
                            ),
                          );
                        },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
