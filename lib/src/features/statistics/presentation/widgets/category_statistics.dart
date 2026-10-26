import 'package:tickly/src/core/extensions/context.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../tasks/domain/entities/task_entity.dart';

class CategoryStatistics extends StatelessWidget {
  const CategoryStatistics({
    super.key,
    required this.tasks,
    required this.categories,
  });
  final List<TaskEntity> tasks;
  final List<CategoryEntity> categories;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final groups = <({String name, Color color, int count})>[];
    final ids = categories.map((c) => c.id).toSet();
    for (final category in categories) {
      final count = tasks.where((t) => t.categoryId == category.id).length;
      if (count > 0) {
        groups.add((
          name: category.name,
          color: Color(category.colorValue),
          count: count,
        ));
      }
    }
    final other = tasks.where((t) => !ids.contains(t.categoryId)).length;
    if (other > 0) {
      groups.add((
        name: context.loc.uncategorized,
        color: colors.outline,
        count: other,
      ));
    }
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.categoryStatisticsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Center(
              child: Semantics(
                label: context.loc.categoryChartSummary(
                  tasks.length,
                  groups.length,
                ),
                child: SizedBox(
                  width: 168,
                  height: 168,
                  child: CustomPaint(
                    painter: _DonutPainter(
                      groups.map((g) => g.count).toList(),
                      groups.map((g) => g.color).toList(),
                      colors.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${tasks.length}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(context.loc.statisticsTotal),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (tasks.isEmpty)
              Center(child: Text(context.loc.categoryStatisticsEmpty)),
            for (final group in groups)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: group.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(group.name)),
                    Text(
                      '${group.count} (${(group.count / tasks.length * 100).toStringAsFixed(1)}%)',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.counts, this.colors, this.emptyColor);
  final List<int> counts;
  final List<Color> colors;
  final Color emptyColor;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final ring = rect.deflate(13);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24;
    final total = counts.fold(0, (a, b) => a + b);
    if (total == 0) {
      canvas.drawOval(ring, paint..color = emptyColor);
      return;
    }
    var start = -math.pi / 2;
    for (var i = 0; i < counts.length; i++) {
      final sweep = counts[i] / total * 2 * math.pi;
      canvas.drawArc(
        ring,
        start,
        sweep - (counts.length > 1 ? .025 : 0),
        false,
        paint..color = colors[i],
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
