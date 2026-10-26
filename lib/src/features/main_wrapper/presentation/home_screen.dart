import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tickly/src/core/presentation/widget/tickly_logo.dart';
import 'package:tickly/src/features/settings/presentation/settings_screen.dart';
import 'package:tickly/src/features/tasks/presentation/utils/task_period.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_search_field.dart';
import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/features/categories/domain/entities/category_entity.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_state.dart';
import 'package:tickly/src/features/categories/presentation/screens/category_screen.dart';
import 'package:tickly/src/features/categories/presentation/widgets/category_filter.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_event.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_state.dart';
import 'package:tickly/src/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:tickly/src/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_card.dart';
import 'package:tickly/src/features/tasks/presentation/utils/task_sort.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_sort_selector.dart';
import 'package:tickly/src/features/statistics/presentation/screens/statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // null: tất cả; '': chưa phân loại; ID: danh mục cụ thể.
  String? _selectedCategoryId;
  int _tab = 0;
  bool _showFilters = false;
  TaskPeriod _period = TaskPeriod.all;
  String _searchQuery = '';
  TaskSortOption _sortOption = TaskSortOption.newest;

  void _openCalendar(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final categoryBloc = context.read<CategoryBloc>();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>.value(value: taskBloc),
            BlocProvider<CategoryBloc>.value(value: categoryBloc),
          ],
          child: const CalendarScreen(),
        ),
      ),
    );
  }

  void _openCreateTask(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final categoryBloc = context.read<CategoryBloc>();

    taskBloc.add(const TaskActionCleared());

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>.value(value: taskBloc),
            BlocProvider<CategoryBloc>.value(value: categoryBloc),
          ],
          child: const CreateTaskScreen(),
        ),
      ),
    );
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

  void _toggleTask(
    BuildContext context, {
    required String taskId,
    required bool isCompleted,
  }) {
    context.read<TaskBloc>().add(
      TaskToggleRequested(taskId: taskId, isCompleted: isCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _tab == 0
          ? AppBar(
              title: Row(
                children: [
                  TicklyLogo(size: 32),
                  SizedBox(width: 10),
                  Text(context.loc.appName),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: context.loc.searchAndFilter,
                  icon: Icon(
                    _showFilters
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                  ),
                  onPressed: () => setState(() => _showFilters = !_showFilters),
                ),
                IconButton(
                  tooltip: context.loc.calendarTitle,
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () => _openCalendar(context),
                ),
                IconButton(
                  tooltip: context.loc.accountTitle,
                  onPressed: () => setState(() => _tab = 3),
                  icon: CircleAvatar(
                    radius: 17,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      (user?.displayName?.trim().isNotEmpty ?? false)
                          ? user!.displayName!
                                .trim()
                                .characters
                                .first
                                .toUpperCase()
                          : 'T',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.assignment_turned_in_rounded),
            label: context.loc.tasksTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: context.loc.categoriesTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: context.loc.statisticsTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: context.loc.settingsTitle,
          ),
        ],
      ),
      body: _tab == 1
          ? CategoryScreen(
              onCategorySelected: (id) => setState(() {
                _selectedCategoryId = id;
                _period = TaskPeriod.all;
                _searchQuery = '';
                _tab = 0;
              }),
            )
          : _tab == 2
          ? const StatisticsScreen()
          : _tab == 3
          ? const SettingsScreen()
          : BlocConsumer<TaskBloc, TaskState>(
              listenWhen: (previous, current) =>
                  previous.actionStatus != current.actionStatus &&
                  current.actionStatus == TaskActionStatus.failure,
              listener: (context, state) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? context.loc.taskUpdateFailed,
                      ),
                    ),
                  ),
              builder: (context, taskState) {
                if (taskState.status == TaskStatusView.initial ||
                    taskState.status == TaskStatusView.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taskState.status == TaskStatusView.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 56,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.loc.taskLoadFailed,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskState.errorMessage ??
                                context.loc.authUnknownError,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => context.read<TaskBloc>().add(
                              const TaskStarted(),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: Text(context.loc.commonRetry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (taskState.tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 80,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.loc.tasksEmptyTitle,
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(context.loc.tasksEmptyDescription),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => _openCreateTask(context),
                            icon: const Icon(Icons.add),
                            label: Text(context.loc.taskCreate),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Row(
                        children: [
                          for (final period in TaskPeriod.values) ...[
                            Expanded(
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Center(
                                  child: Text(period.label(context)),
                                ),
                                selected: _period == period,
                                onSelected: (_) =>
                                    setState(() => _period = period),
                              ),
                            ),
                            if (period != TaskPeriod.upcoming)
                              const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _period == TaskPeriod.all
                                      ? context.loc.yourTasks
                                      : _period.label(context),
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  MaterialLocalizations.of(
                                    context,
                                  ).formatFullDate(DateTime.now()),
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 88,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  context.loc.completionCount(
                                    taskState.completedCount,
                                    taskState.totalTasks,
                                  ),
                                  style: context.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: taskState.completionProgress,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          final categories = categoryState.categories;
                          final categoryMap = <String, CategoryEntity>{
                            for (final category in categories)
                              category.id: category,
                          };

                          // Nếu bộ lọc tham chiếu một danh mục vừa bị xóa, hiển thị Tất cả.
                          final filterId =
                              _selectedCategoryId == null ||
                                  _selectedCategoryId == '' ||
                                  categoryMap.containsKey(_selectedCategoryId)
                              ? _selectedCategoryId
                              : null;

                          final query = _searchQuery.trim().toLowerCase();

                          final filteredTasks = taskState.tasks.where((task) {
                            final matchesCategory =
                                filterId == null ||
                                (filterId.isEmpty
                                    ? task.categoryId == null ||
                                          task.categoryId!.isEmpty
                                    : task.categoryId == filterId);

                            final matchesSearch =
                                query.isEmpty ||
                                task.title.toLowerCase().contains(query) ||
                                (task.description ?? '').toLowerCase().contains(
                                  query,
                                );

                            return matchesCategory &&
                                matchesSearch &&
                                _period.includes(task, DateTime.now());
                          }).toList();
                          final sortedTasks = sortTasks(
                            filteredTasks,
                            _sortOption,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_showFilters)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    12,
                                  ),
                                  child: TaskSearchField(
                                    query: _searchQuery,
                                    onChanged: (value) {
                                      setState(() => _searchQuery = value);
                                    },
                                  ),
                                ),
                              if (categoryState.status ==
                                      CategoryViewStatus.loading ||
                                  categoryState.status ==
                                      CategoryViewStatus.initial)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: LinearProgressIndicator(),
                                )
                              else if (categoryState.status ==
                                  CategoryViewStatus.failure)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    context.loc.categoriesUnavailable,
                                  ),
                                )
                              else if (_showFilters || filterId != null)
                                CategoryFilter(
                                  categories: categories,
                                  selectedCategoryId: filterId,
                                  onChanged: (id) =>
                                      setState(() => _selectedCategoryId = id),
                                ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  12,
                                  20,
                                  8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        context.loc.taskCount(
                                          filteredTasks.length,
                                        ),
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ),
                                    TaskSortSelector(
                                      value: _sortOption,
                                      onChanged: (value) =>
                                          setState(() => _sortOption = value),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: sortedTasks.isEmpty
                                    ? Center(
                                        child: Text(
                                          context.loc.noMatchingTasks,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          100,
                                        ),
                                        itemCount: sortedTasks.length,
                                        itemBuilder: (context, index) {
                                          final task = sortedTasks[index];

                                          final category =
                                              categoryMap[task.categoryId];

                                          return TaskCard(
                                            task: task,
                                            category: category,
                                            enabled:
                                                taskState.actionStatus !=
                                                TaskActionStatus.loading,
                                            onTap: () => _openTaskDetail(
                                              context,
                                              task.id,
                                            ),
                                            onToggle: (value) {
                                              _toggleTask(
                                                context,
                                                taskId: task.id,
                                                isCompleted: value,
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: _tab != 0
          ? null
          : FloatingActionButton(
              onPressed: () => _openCreateTask(context),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              tooltip: context.loc.taskCreate,
              child: const Icon(Icons.add_rounded),
            ),
    );
  }
}
