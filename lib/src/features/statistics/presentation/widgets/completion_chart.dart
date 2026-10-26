import 'package:tickly/src/core/localization/date_formatting.dart';
import 'package:tickly/src/core/extensions/context.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';

enum CompletionPeriod { sevenDays, thirtyDays }

class CompletionChart extends StatefulWidget {
  const CompletionChart({super.key, required this.tasks});

  final List<TaskEntity> tasks;

  @override
  State<CompletionChart> createState() => _CompletionChartState();
}

class _CompletionChartState extends State<CompletionChart> {
  CompletionPeriod _period = CompletionPeriod.sevenDays;

  int get _numberOfDays {
    return _period == CompletionPeriod.sevenDays ? 7 : 30;
  }

  // ==================== CALCULATE DATA ====================

  List<_DailyCompletion> _calculateData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(_numberOfDays, (index) {
      final daysAgo = _numberOfDays - 1 - index;

      final day = DateTime(today.year, today.month, today.day - daysAgo);

      var completed = 0;

      for (final task in widget.tasks) {
        if (!task.isCompleted || task.completedAt == null) {
          continue;
        }

        final completedAt = task.completedAt!.toLocal();

        final completedDay = DateTime(
          completedAt.year,
          completedAt.month,
          completedAt.day,
        );

        if (completedDay == day) {
          completed++;
        }
      }

      return _DailyCompletion(date: day, count: completed);
    });
  }

  String _dayLabel(DateTime date) => _period == CompletionPeriod.sevenDays
      ? MaterialLocalizations.of(context).narrowWeekdays[date.weekday % 7]
      : localizedDate(context, date);

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final data = _calculateData();

    final maxCount = data.fold<int>(
      0,
      (maximum, item) => math.max(maximum, item.count),
    );

    final totalCompleted = data.fold<int>(
      0,
      (total, item) => total + item.count,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.completionPerformance,
              style: textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            Text(
              context.loc.completionByDay,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            // ==================== FILTER ====================
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(context.loc.periodSevenDays),
                  selected: _period == CompletionPeriod.sevenDays,
                  onSelected: (_) {
                    setState(() {
                      _period = CompletionPeriod.sevenDays;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(context.loc.periodThirtyDays),
                  selected: _period == CompletionPeriod.thirtyDays,
                  onSelected: (_) {
                    setState(() {
                      _period = CompletionPeriod.thirtyDays;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              context.loc.completedTaskCount(totalCompleted),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // ==================== CHART ====================
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 6.0;

                final barWidth = _period == CompletionPeriod.sevenDays
                    ? math.max(32.0, (constraints.maxWidth - spacing * 6) / 7)
                    : 38.0;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < data.length; i++) ...[
                        _BarItem(
                          width: barWidth,
                          count: data[i].count,
                          maxCount: maxCount,
                          label: _dayLabel(data[i].date),
                          isToday: i == data.length - 1,
                        ),
                        if (i < data.length - 1) const SizedBox(width: spacing),
                      ],
                    ],
                  ),
                );
              },
            ),

            if (maxCount == 0) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  context.loc.completionEmpty,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== DAILY DATA ====================

class _DailyCompletion {
  const _DailyCompletion({required this.date, required this.count});

  final DateTime date;
  final int count;
}

// ==================== BAR ITEM ====================

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.width,
    required this.count,
    required this.maxCount,
    required this.label,
    required this.isToday,
  });

  final double width;
  final int count;
  final int maxCount;
  final String label;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const chartHeight = 130.0;

    final ratio = maxCount == 0 ? 0.0 : count / maxCount;

    final barHeight = count == 0 ? 0.0 : math.max(6.0, ratio * chartHeight);

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Giá trị trên đầu cột.
          Text('$count', style: textTheme.labelSmall),

          const SizedBox(height: 8),

          // Cột biểu đồ.
          SizedBox(
            height: chartHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: math.min(width * 0.65, 28),
                height: barHeight,
                decoration: BoxDecoration(
                  color: isToday ? colors.primary : colors.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Ngày.
          Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: isToday ? colors.primary : colors.onSurfaceVariant,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
