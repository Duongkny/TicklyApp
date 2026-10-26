import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';

class TaskInformation extends StatelessWidget {
  const TaskInformation({super.key, required this.task});

  final TaskEntity task;

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return context.loc.notSet;

    final localDate = date.toLocal();
    final material = MaterialLocalizations.of(context);

    final dateText = material.formatMediumDate(localDate);
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDate),
      alwaysUse24HourFormat: true,
    );

    return '$dateText, $timeText';
  }

  String _priorityLabel(BuildContext context) {
    return switch (task.priority) {
      TaskPriority.low => context.loc.priorityLow,
      TaskPriority.medium => context.loc.priorityMedium,
      TaskPriority.high => context.loc.priorityHigh,
    };
  }

  Color _priorityColor(ColorScheme colors) {
    return switch (task.priority) {
      TaskPriority.low => colors.tertiary,
      TaskPriority.medium => colors.primary,
      TaskPriority.high => colors.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InformationRow(
          icon: Icons.flag_outlined,
          label: context.loc.priorityTitle,
          value: _priorityLabel(context),
          valueColor: _priorityColor(colors),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.calendar_today_outlined,
          label: context.loc.dueDate,
          value: _formatDate(context, task.dueDate),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.notifications_none_rounded,
          label: context.loc.reminderLabel,
          value: _formatDate(context, task.reminderAt),
        ),

        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.access_time_rounded,
          label: context.loc.createdDate,
          value: _formatDate(context, task.createdAt),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.update_rounded,
          label: context.loc.lastUpdated,
          value: _formatDate(context, task.updatedAt),
        ),
      ],
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: colors.onSurfaceVariant),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
