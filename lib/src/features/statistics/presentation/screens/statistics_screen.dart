import 'package:tickly/src/core/extensions/context.dart';
import '../widgets/completion_chart.dart';
import '../widgets/category_statistics.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';

import '../../domain/usecases/calculate_statistics_usecase.dart';
import '../widgets/statistics_summary.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.loc.statisticsPageTitle),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatusView.loading ||
              state.status == TaskStatusView.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskStatusView.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? context.loc.statisticsLoadFailed,
              ),
            );
          }

          final statistics = const CalculateStatistics()(state.tasks);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Tổng quan công việc.
              StatisticsSummary(statistics: statistics),

              const SizedBox(height: 20),

              // Biểu đồ 7 ngày / 30 ngày.
              CompletionChart(tasks: state.tasks),
              const SizedBox(height: 20),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, categories) {
                  if (categories.status == CategoryViewStatus.failure) {
                    return Text(context.loc.categoryStatisticsFailed);
                  }

                  if (categories.status != CategoryViewStatus.success) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CategoryStatistics(
                    tasks: state.tasks,
                    categories: categories.categories,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
