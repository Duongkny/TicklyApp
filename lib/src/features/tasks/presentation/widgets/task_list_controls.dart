import 'package:tickly/src/core/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';

enum TaskStatusFilter { pending, completed }

enum TaskSortOption {
  newest,
  oldest,
  priorityHigh,
  priorityLow,
  dueSoon,
  dueLate,
}

extension TaskStatusFilterText on TaskStatusFilter {
  String label(BuildContext context) => switch (this) {
    TaskStatusFilter.pending => context.loc.statusPending,
    TaskStatusFilter.completed => context.loc.statusCompleted,
  };
}

extension TaskSortOptionText on TaskSortOption {
  String label(BuildContext context) => switch (this) {
    TaskSortOption.newest => context.loc.sortNewest,
    TaskSortOption.oldest => context.loc.sortOldest,
    TaskSortOption.priorityHigh => context.loc.sortPriorityHigh,
    TaskSortOption.priorityLow => context.loc.sortPriorityLow,
    TaskSortOption.dueSoon => context.loc.sortDueSoon,
    TaskSortOption.dueLate => context.loc.sortDueLate,
  };
}

/// Trả về danh sách mới, không thay đổi state.tasks của Bloc.
List<TaskEntity> sortTaskList(List<TaskEntity> tasks, TaskSortOption option) {
  final sorted = List<TaskEntity>.of(tasks);
  int priorityRank(TaskPriority p) => switch (p) {
    TaskPriority.low => 1,
    TaskPriority.medium => 2,
    TaskPriority.high => 3,
  };

  int compareDue(TaskEntity a, TaskEntity b, {required bool ascending}) {
    final x = a.dueDate;
    final y = b.dueDate;
    if (x == null && y == null) return 0;
    if (x == null) return 1;
    if (y == null) return -1;
    return ascending ? x.compareTo(y) : y.compareTo(x);
  }

  sorted.sort((a, b) {
    final result = switch (option) {
      TaskSortOption.newest => b.createdAt.compareTo(a.createdAt),
      TaskSortOption.oldest => a.createdAt.compareTo(b.createdAt),
      TaskSortOption.priorityHigh => priorityRank(
        b.priority,
      ).compareTo(priorityRank(a.priority)),
      TaskSortOption.priorityLow => priorityRank(
        a.priority,
      ).compareTo(priorityRank(b.priority)),
      TaskSortOption.dueSoon => compareDue(a, b, ascending: true),
      TaskSortOption.dueLate => compareDue(a, b, ascending: false),
    };
    if (result != 0) return result;
    final secondary = b.createdAt.compareTo(a.createdAt);
    return secondary != 0 ? secondary : a.id.compareTo(b.id);
  });
  return sorted;
}

class TaskStatusFilterBar extends StatelessWidget {
  const TaskStatusFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final TaskStatusFilter value;
  final ValueChanged<TaskStatusFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: TaskStatusFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = TaskStatusFilter.values[index];
          return ChoiceChip(
            label: Text(option.label(context)),
            selected: value == option,
            onSelected: (_) => onChanged(option),
          );
        },
      ),
    );
  }
}

class TaskSortMenu extends StatelessWidget {
  const TaskSortMenu({super.key, required this.value, required this.onChanged});
  final TaskSortOption value;
  final ValueChanged<TaskSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskSortOption>(
      tooltip: context.loc.sortTasks,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => TaskSortOption.values.map((option) {
        return PopupMenuItem<TaskSortOption>(
          value: option,
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: option == value
                    ? const Icon(Icons.check, size: 18)
                    : null,
              ),
              const SizedBox(width: 6),
              Text(option.label(context)),
            ],
          ),
        );
      }).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 19),
            const SizedBox(width: 6),
            Text(value.label(context)),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}
