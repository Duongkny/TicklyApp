
import 'package:tickly/src/features/statistics/domain/entites/statistics_entity.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';



class CalculateStatistics {
  const CalculateStatistics();

  StatisticsEntity call(
    List<TaskEntity> tasks, {
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    var completed = 0;
    var pending = 0;
    var overdue = 0;

    for (final task in tasks) {
      if (task.isCompleted) {
        completed++;
      } else {
        pending++;

        if (task.dueDate != null &&
            task.dueDate!.isBefore(currentTime)) {
          overdue++;
        }
      }
    }

    return StatisticsEntity(
      totalTasks: tasks.length,
      completedTasks: completed,
      pendingTasks: pending,
      overdueTasks: overdue,
    );
  }
  
int countCompletedBetween(
  List<TaskEntity> tasks, {
  required DateTime start,
  required DateTime end,
}) {
  return tasks.where((task) {
    final completedAt = task.completedAt;

    if (!task.isCompleted || completedAt == null) {
      return false;
    }

    return !completedAt.isBefore(start) &&
        completedAt.isBefore(end);
  }).length;
}

}
