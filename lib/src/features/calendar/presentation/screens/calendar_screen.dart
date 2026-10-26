import 'package:tickly/src/core/localization/date_formatting.dart';
import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';
import 'package:tickly/src/features/tasks/presentation/screens/task_detail_screen.dart';

enum CalendarViewMode { month, week }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  CalendarViewMode _viewMode = CalendarViewMode.month;

  List<String> get _weekdays =>
      MaterialLocalizations.of(context).narrowWeekdays;

  bool _sameDay(DateTime a, DateTime b) {
    return DateUtils.isSameDay(a, b);
  }

  DateTime _startOfWeek(DateTime date) {
    final daysFromSunday = date.weekday % 7;
    return DateUtils.dateOnly(date.subtract(Duration(days: daysFromSunday)));
  }

  List<DateTime> _visibleDates() {
    if (_viewMode == CalendarViewMode.week) {
      final start = _startOfWeek(_selectedDate);
      return List.generate(7, (index) => start.add(Duration(days: index)));
    }

    final first = DateTime(_selectedDate.year, _selectedDate.month, 1);

    final start = _startOfWeek(first);

    final last = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    final daysCount = last.difference(start).inDays + 1;

    final cellCount = ((daysCount + 6) ~/ 7) * 7;

    return List.generate(
      cellCount,
      (index) => start.add(Duration(days: index)),
    );
  }

  void _movePeriod(int direction) {
    setState(() {
      if (_viewMode == CalendarViewMode.week) {
        _selectedDate = _selectedDate.add(Duration(days: 7 * direction));
      } else {
        final targetMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month + direction,
          1,
        );

        final lastDay = DateTime(
          targetMonth.year,
          targetMonth.month + 1,
          0,
        ).day;

        _selectedDate = DateTime(
          targetMonth.year,
          targetMonth.month,
          _selectedDate.day.clamp(1, lastDay),
        );
      }
    });
  }

  String _dateLabel(DateTime date) => localizedDate(context, date);
  String _timeLabel(DateTime date) => localizedTime(context, date);

  List<TaskEntity> _tasksOnDate(List<TaskEntity> tasks, DateTime date) {
    final selected = tasks.where((task) {
      final dueDate = task.dueDate?.toLocal();

      return dueDate != null && _sameDay(dueDate, date);
    }).toList();

    selected.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return selected;
  }

  void _openTaskDetail(BuildContext context, String taskId) {
    final taskBloc = context.read<TaskBloc>();
    final categoryBloc = context.read<CategoryBloc>();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>.value(value: taskBloc),
            BlocProvider<CategoryBloc>.value(value: categoryBloc),
          ],
          child: TaskDetailScreen(taskId: taskId),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, List<TaskEntity> tasks) {
    final colors = Theme.of(context).colorScheme;
    final today = DateUtils.dateOnly(DateTime.now());
    final visibleDates = _visibleDates();

    // Đếm số Task theo ngày trong vùng lịch đang xem.
    final counts = <DateTime, int>{};

    for (final task in tasks) {
      final dueDate = task.dueDate?.toLocal();

      if (dueDate == null) continue;

      final day = DateUtils.dateOnly(dueDate);
      counts[day] = (counts[day] ?? 0) + 1;
    }

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: context.loc.previous,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _movePeriod(-1),
                ),
                Expanded(
                  child: Text(
                    MaterialLocalizations.of(
                      context,
                    ).formatMonthYear(_selectedDate),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.loc.next,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _movePeriod(1),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                for (final label in _weekdays)
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleDates.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.84,
              ),
              itemBuilder: (context, index) {
                final date = visibleDates[index];

                final isSelected = _sameDay(date, _selectedDate);

                final isToday = _sameDay(date, today);

                final isCurrentMonth =
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;

                final count = counts[DateUtils.dateOnly(date)] ?? 0;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday && !isSelected
                          ? Border.all(color: colors.primary)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? colors.onPrimary
                                : isCurrentMonth
                                ? colors.onSurface
                                : colors.onSurfaceVariant.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (count > 0)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskEntity task) {
    final colors = Theme.of(context).colorScheme;
    final dueDate = task.dueDate!.toLocal();

    final isOverdue = !task.isCompleted && dueDate.isBefore(DateTime.now());

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: colors.surfaceContainerLow,
      child: ListTile(
        onTap: () => _openTaskDetail(context, task.id),
        leading: Icon(
          task.isCompleted
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: task.isCompleted
              ? colors.primary
              : isOverdue
              ? colors.error
              : colors.onSurfaceVariant,
        ),
        title: Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isOverdue
              ? context.loc.overdueAt(_timeLabel(dueDate))
              : context.loc.dueAt(_timeLabel(dueDate)),
          style: TextStyle(
            color: isOverdue ? colors.error : colors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(context.loc.calendarTitle),
        actions: [
          IconButton(
            tooltip: context.loc.today,
            icon: const Icon(Icons.today_rounded),
            onPressed: () {
              setState(() {
                _selectedDate = DateUtils.dateOnly(DateTime.now());
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatusView.initial ||
              state.status == TaskStatusView.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskStatusView.failure) {
            return Center(
              child: Text(state.errorMessage ?? context.loc.taskLoadFailed),
            );
          }

          final selectedTasks = _tasksOnDate(state.tasks, _selectedDate);

          final completedCount = selectedTasks
              .where((task) => task.isCompleted)
              .length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
            children: [
              // Chế độ xem.
              SegmentedButton<CalendarViewMode>(
                segments: [
                  ButtonSegment(
                    value: CalendarViewMode.month,
                    icon: Icon(Icons.calendar_month),
                    label: Text(context.loc.calendarMonth),
                  ),
                  ButtonSegment(
                    value: CalendarViewMode.week,
                    icon: Icon(Icons.view_week_outlined),
                    label: Text(context.loc.calendarWeek),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (selection) {
                  setState(() {
                    _viewMode = selection.first;
                  });
                },
              ),

              const SizedBox(height: 16),

              _buildCalendar(context, state.tasks),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.loc.calendarDate(_dateLabel(_selectedDate)),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    context.loc.taskCount(selectedTasks.length),
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                context.loc.completionCount(
                  completedCount,
                  selectedTasks.length,
                ),
                style: TextStyle(color: colors.onSurfaceVariant),
              ),

              const SizedBox(height: 16),

              if (selectedTasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available_outlined,
                        size: 56,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.loc.noTasksDue,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              else
                ...selectedTasks.map((task) => _buildTaskItem(context, task)),
            ],
          );
        },
      ),
    );
  }
}
