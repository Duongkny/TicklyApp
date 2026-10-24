
import '../../domain/entities/task_entity.dart';
import '../widgets/task_sort_selector.dart';

List<TaskEntity> sortTasks(
  List<TaskEntity> tasks,
  TaskSortOption option,
) {
  final result = List<TaskEntity>.of(tasks);

  int comparePriority(TaskEntity a, TaskEntity b) {
    int rank(TaskPriority priority) {
      return switch (priority) {
        TaskPriority.low => 1,
        TaskPriority.medium => 2,
        TaskPriority.high => 3,
      };
    }

    return rank(a.priority).compareTo(rank(b.priority));
  }

  int compareDueDate(
    TaskEntity a,
    TaskEntity b, {
    required bool ascending,
  }) {
    final aDate = a.dueDate;
    final bDate = b.dueDate;

    // Task không có hạn luôn nằm cuối.
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;

    return ascending
        ? aDate.compareTo(bDate)
        : bDate.compareTo(aDate);
  }

  result.sort((a, b) {
    final comparison = switch (option) {
      TaskSortOption.newest =>
        b.createdAt.compareTo(a.createdAt),

      TaskSortOption.oldest =>
        a.createdAt.compareTo(b.createdAt),

      TaskSortOption.priorityHigh =>
        comparePriority(b, a),

      TaskSortOption.priorityLow =>
        comparePriority(a, b),

      TaskSortOption.dueSoon =>
        compareDueDate(a, b, ascending: true),

      TaskSortOption.dueLate =>
        compareDueDate(a, b, ascending: false),
    };

    // Nếu hai Task có cùng giá trị sắp xếp,
    // ưu tiên Task mới hơn, sau đó dùng ID để ổn định.
    if (comparison != 0) return comparison;

    final createdComparison =
        b.createdAt.compareTo(a.createdAt);

    if (createdComparison != 0) return createdComparison;

    return a.id.compareTo(b.id);
  });

  return result;
}
