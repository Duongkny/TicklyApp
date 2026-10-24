import 'package:flutter/material.dart';
import 'package:tickly/src/features/categories/domain/entities/category_entity.dart';
import 'package:tickly/src/features/categories/presentation/widgets/category_badge.dart';

import '../../domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    this.enabled = true,
    this.category,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final bool enabled;
  final CategoryEntity? category;

  String get _priorityText => switch (task.priority) {
        TaskPriority.low => 'Thấp',
        TaskPriority.medium => 'Vừa',
        TaskPriority.high => 'Cao',
      };

  Color _priorityColor(ColorScheme colors) => switch (task.priority) {
        TaskPriority.low => colors.tertiary,
        TaskPriority.medium => colors.primary,
        TaskPriority.high => colors.error,
      };

  String _formatDueDate(DateTime value) {
    final date = value.toLocal();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final description = task.description?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: task.isCompleted,
                activeColor: colors.primary,
                onChanged: enabled
                    ? (value) {
                        if (value != null) onToggle(value);
                      }
                    : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: task.isCompleted
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (category != null) CategoryBadge(category: category!),
                        _MetaLabel(
                          icon: Icons.flag_outlined,
                          label: _priorityText,
                          color: _priorityColor(colors),
                        ),
                        if (task.dueDate != null)
                          _MetaLabel(
                            icon: Icons.event_outlined,
                            label: _formatDueDate(task.dueDate!),
                            color: colors.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  const _MetaLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
