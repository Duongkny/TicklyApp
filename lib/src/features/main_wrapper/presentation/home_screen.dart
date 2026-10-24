import 'package:flutter/material.dart';
import 'package:tickly/src/core/notification/task_reminder_service.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // null: tất cả; '': chưa phân loại; ID: danh mục cụ thể.
  String? _selectedCategoryId;
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

  void _openCategories(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const CategoryScreen(),
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: colorScheme.surface,
        centerTitle: false,
        actions: [
           IconButton(
      tooltip: 'Test thông báo',
      icon: const Icon(Icons.notifications_active_outlined),
      onPressed: () async {
        try {
          final service = TaskReminderService.instance;

          final granted = await service.requestPermission();

          if (!context.mounted) return;

          if (!granted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Chưa cấp quyền thông báo'),
              ),
            );
            return;
          }

          await service.showTestNotification();

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã gửi thông báo thử nghiệm'),
            ),
          );
        } catch (error) {
          debugPrint('Notification test error: $error');

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi thông báo: $error'),
            ),
          );
        }
      },
    ),

          IconButton(
            tooltip: 'Lịch công việc',
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => _openCalendar(context),
          ),
          IconButton(
            tooltip: 'Danh mục',
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => _openCategories(context),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
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
                      'Không thể tải danh sách công việc',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      taskState.errorMessage ??
                          'Đã xảy ra lỗi. Vui lòng thử lại.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<TaskBloc>().add(const TaskStarted()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
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
                      'Chưa có công việc nào',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Hãy thêm công việc đầu tiên của bạn!'),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _openCreateTask(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Tạo công việc'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: colorScheme.primaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tiến độ công việc',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(taskState.completionProgress * 100).round()}%',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${taskState.completedCount}/${taskState.totalTasks} đã hoàn thành',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: taskState.completionProgress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: colorScheme.surface,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách công việc',
                      style: context.textTheme.titleMedium,
                    ),
                    Text('${taskState.totalTasks} công việc'),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    final categories = categoryState.categories;
                    final categoryMap = <String, CategoryEntity>{
                      for (final category in categories) category.id: category,
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

                      return matchesCategory && matchesSearch;
                    }).toList();
                    final sortedTasks = sortTasks(filteredTasks, _sortOption);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: TaskSearchField(
                            query: _searchQuery,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                          ),
                        ),
                        if (categoryState.status ==
                                CategoryViewStatus.loading ||
                            categoryState.status == CategoryViewStatus.initial)
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Không thể tải danh mục; đang hiển thị công việc đã tải.',
                            ),
                          )
                        else
                          CategoryFilter(
                            categories: categories,
                            selectedCategoryId: filterId,
                            onChanged: (id) =>
                                setState(() => _selectedCategoryId = id),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                          child: Text(
                            '${filteredTasks.length} công việc trong bộ lọc',
                          ),
                        ),
                        Expanded(
                          child: sortedTasks.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Không tìm thấy công việc phù hợp',
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
                                      onTap: () =>
                                          _openTaskDetail(context, task.id),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateTask(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm công việc'),
      ),
    );
  }
}
