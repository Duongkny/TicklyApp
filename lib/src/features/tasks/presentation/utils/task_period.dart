import 'package:flutter/material.dart';
import 'package:tickly/src/core/extensions/context.dart';
import '../../domain/entities/task_entity.dart';

enum TaskPeriod { all, today, upcoming }

extension TaskPeriodFilter on TaskPeriod {
  String label(BuildContext context) => switch (this) {
    TaskPeriod.all => context.loc.filterAll,
    TaskPeriod.today => context.loc.today,
    TaskPeriod.upcoming => context.loc.upcoming,
  };
  bool includes(TaskEntity task, DateTime now) {
    if (this == TaskPeriod.all) return true;
    final due = task.dueDate?.toLocal();
    if (due == null) return false;
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return this == TaskPeriod.today
        ? !due.isBefore(today) && due.isBefore(tomorrow)
        : !due.isBefore(tomorrow);
  }
}
