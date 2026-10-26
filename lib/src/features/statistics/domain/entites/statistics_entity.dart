class StatisticsEntity {
  const StatisticsEntity({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
  });

  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;

  double get completionRate {
    if (totalTasks == 0) return 0;

    return completedTasks / totalTasks;
  }
}
