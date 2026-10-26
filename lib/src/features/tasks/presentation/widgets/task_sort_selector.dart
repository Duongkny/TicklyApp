import 'package:tickly/src/core/extensions/context.dart';

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
  String label(BuildContext context) => switch (this) {
    TaskSortOption.newest => context.loc.sortNewest,
    TaskSortOption.oldest => context.loc.sortOldest,
    TaskSortOption.priorityHigh => context.loc.sortPriorityHigh,
    TaskSortOption.priorityLow => context.loc.sortPriorityLow,
    TaskSortOption.dueSoon => context.loc.sortDueSoon,
    TaskSortOption.dueLate => context.loc.sortDueLate,
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
      tooltip: context.loc.sortTasks,
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
                Text(option.label(context)),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 20),
            const SizedBox(width: 8),
            Flexible(child: Text(value.label(context))),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}
