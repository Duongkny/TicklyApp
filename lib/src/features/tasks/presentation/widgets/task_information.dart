
import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';

class TaskInformation extends StatelessWidget {
  const TaskInformation({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return 'Chưa đặt';

    final localDate = date.toLocal();
    final material = MaterialLocalizations.of(context);

    final dateText = material.formatMediumDate(localDate);
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDate),
      alwaysUse24HourFormat: true,
    );

    return '$dateText, $timeText';
  }

  String get _priorityLabel {
    return switch (task.priority) {
      TaskPriority.low => 'Thấp',
      TaskPriority.medium => 'Trung bình',
      TaskPriority.high => 'Cao',
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
          label: 'Mức độ ưu tiên',
          value: _priorityLabel,
          valueColor: _priorityColor(colors),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.calendar_today_outlined,
          label: 'Hạn hoàn thành',
          value: _formatDate(context, task.dueDate),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.notifications_none_rounded,
          label: 'Nhắc nhở',
          value: _formatDate(context, task.reminderAt),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.access_time_rounded,
          label: 'Ngày tạo',
          value: _formatDate(context, task.createdAt),
        ),
        const SizedBox(height: 18),

        _InformationRow(
          icon: Icons.update_rounded,
          label: 'Cập nhật lần cuối',
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
        Icon(
          icon,
          size: 22,
          color: colors.onSurfaceVariant,
        ),
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
