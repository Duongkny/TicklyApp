import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';
import 'package:tickly/src/features/statistics/domain/entites/statistics_entity.dart';

class StatisticsSummary extends StatelessWidget {
  const StatisticsSummary({super.key, required this.statistics});

  final StatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.statisticsOverview, style: textTheme.titleLarge),

        const SizedBox(height: 16),

        // ==================== STATISTICS GRID ====================
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 142,
          children: [
            _StatisticCard(
              title: context.loc.statisticsTotalTasks,
              count: statistics.totalTasks,
              icon: Icons.list_alt_rounded,
              color: colors.primary,
            ),
            _StatisticCard(
              title: context.loc.statusCompleted,
              count: statistics.completedTasks,
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
            _StatisticCard(
              title: context.loc.statusPending,
              count: statistics.pendingTasks,
              icon: Icons.pending_actions_outlined,
              color: Colors.orange,
            ),
            _StatisticCard(
              title: context.loc.statusOverdue,
              count: statistics.overdueTasks,
              icon: Icons.warning_amber_rounded,
              color: colors.error,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ==================== PROGRESS ====================
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.completionProgress,
                  style: textTheme.titleMedium,
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(
                  value: statistics.completionRate,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),

                const SizedBox(height: 12),

                Text(
                  '${(statistics.completionRate * 100).toStringAsFixed(1)}% '
                  '(${statistics.completedTasks}/${statistics.totalTasks})',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== STATISTIC CARD ====================

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),

            const Spacer(),

            Text(
              '$count',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
