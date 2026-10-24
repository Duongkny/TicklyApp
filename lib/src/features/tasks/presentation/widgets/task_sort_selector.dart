
import 'package:flutter/material.dart';

enum TaskSortOption {
  newest,
  oldest,
  priorityHigh,
  priorityLow,
  dueSoon,
  dueLate,
}

extension TaskSortOptionLabel on TaskSortOption {
  String get label => switch (this) {
    TaskSortOption.newest => 'Mới nhất',
    TaskSortOption.oldest => 'Cũ nhất',
    TaskSortOption.priorityHigh => 'Ưu tiên cao',
    TaskSortOption.priorityLow => 'Ưu tiên thấp',
    TaskSortOption.dueSoon => 'Hạn gần nhất',
    TaskSortOption.dueLate => 'Hạn xa nhất',
  };
}

class TaskSortSelector extends StatelessWidget {
  const TaskSortSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskSortOption value;
  final ValueChanged<TaskSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskSortOption>(
      tooltip: 'Sắp xếp công việc',
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final option in TaskSortOption.values)
          PopupMenuItem<TaskSortOption>(
            value: option,
            child: Row(
              children: [
                if (option == value) ...[
                  const Icon(Icons.check_rounded, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(option.label),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 20),
            const SizedBox(width: 8),
            Flexible(child: Text(value.label)),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}
