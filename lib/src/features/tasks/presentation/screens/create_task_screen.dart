import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/core/notification/reminder_permissions.dart';
import 'package:tickly/src/core/localization/date_formatting.dart';
import 'package:tickly/src/core/extensions/context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/features/categories/presentation/widgets/category_selector.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';

import 'package:tickly/src/features/categories/presentation/bloc/category_state.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  String? _categoryId;
  DateTime? _reminderAt;

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ==================== SELECT DUE DATE ====================

  Future<void> _selectDueDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 10),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _dueDate == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(_dueDate!),
    );

    if (time == null || !mounted) return;

    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _selectReminder() async {
    final now = DateTime.now();

    final initial = _reminderAt != null && _reminderAt!.isAfter(now)
        ? _reminderAt!
        : now.add(const Duration(minutes: 5));

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateUtils.dateOnly(now),
      lastDate: DateTime(now.year + 10),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null || !mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (!selected.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.reminderMustBeFuture)));
      return;
    }

    if (!await prepareTaskReminder(context) || !mounted) return;
    if (!selected.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.reminderMustBeFuture)));
      return;
    }
    setState(() {
      _reminderAt = selected;
    });
  }

  // ==================== SUBMIT TASK ====================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskState = context.read<TaskBloc>().state;

    if (taskState.actionStatus == TaskActionStatus.loading) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.signInRequired)));
      return;
    }

    // Kiểm tra danh mục trước khi lưu.
    final categoryState = context.read<CategoryBloc>().state;

    String? selectedCategoryId;

    if (_categoryId != null) {
      if (categoryState.status != CategoryViewStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.categoryNotConfirmed)),
        );
        return;
      }

      final exists = categoryState.categories.any(
        (category) => category.id == _categoryId,
      );

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.categoryNoLongerExists)),
        );
        return;
      }

      selectedCategoryId = _categoryId;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    final now = DateTime.now();

    final task = TaskEntity(
      id: '',
      userId: user.uid,
      title: title,
      description: description.isEmpty ? null : description,

      // Lưu danh mục đã chọn.
      categoryId: selectedCategoryId,
      reminderAt: _reminderAt,
      priority: _priority,
      status: TaskStatus.pending,
      dueDate: _dueDate,
      createdAt: now,
      updatedAt: now,
    );

    context.read<TaskBloc>().add(TaskCreateRequested(task));
  }

  // ==================== CATEGORY DROPDOWN ====================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) {
        return current.action == TaskAction.create &&
            previous.actionStatus != current.actionStatus;
      },
      listener: (context, state) {
        if (state.actionStatus == TaskActionStatus.success) {
          Navigator.of(context).pop();
        }

        if (state.actionStatus == TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.loc.taskCreateFailed),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Text(context.loc.taskCreate),
          backgroundColor: colors.surface,
        ),

        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ==================== TITLE ====================
                InputField(
                  controller: _titleController,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: context.loc.taskTitleLabel,
                    hintText: context.loc.taskTitleHint,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.loc.taskTitleRequired;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================== DESCRIPTION ====================
                InputField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: context.loc.taskDescriptionLabel,
                    hintText: context.loc.taskDescriptionHint,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== CATEGORY ====================
                Text(
                  context.loc.categoriesTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

                CategorySelector(
                  selectedCategoryId: _categoryId,
                  onChanged: (categoryId) {
                    setState(() {
                      _categoryId = categoryId;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // ==================== PRIORITY ====================
                Text(
                  context.loc.priorityTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

                SegmentedButton<TaskPriority>(
                  segments: [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text(context.loc.priorityLow),
                    ),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text(context.loc.priorityMedium),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text(context.loc.priorityHigh),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (values) {
                    setState(() {
                      _priority = values.first;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // ==================== DUE DATE ====================
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    color: colors.primary,
                  ),
                  title: Text(context.loc.dueDateTime),
                  subtitle: Text(
                    _dueDate == null
                        ? context.loc.notSelected
                        : localizedDateTime(context, _dueDate!),
                  ),
                  trailing: _dueDate == null
                      ? const Icon(Icons.chevron_right)
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _dueDate = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                  onTap: _selectDueDate,
                ),

                const SizedBox(height: 32),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.notifications_active_outlined,
                    color: colors.primary,
                  ),
                  title: Text(context.loc.taskReminders),
                  subtitle: Text(
                    _reminderAt == null
                        ? context.loc.reminderNotSet
                        : localizedDateTime(context, _reminderAt!),
                  ),
                  trailing: _reminderAt == null
                      ? const Icon(Icons.chevron_right)
                      : IconButton(
                          tooltip: context.loc.removeReminder,
                          onPressed: () {
                            setState(() {
                              _reminderAt = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                  onTap: _selectReminder,
                ),
                const SizedBox(height: 32),

                // ==================== CREATE BUTTON ====================
                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    final isLoading =
                        state.action == TaskAction.create &&
                        state.actionStatus == TaskActionStatus.loading;

                    return FilledButton(
                      onPressed: isLoading ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.loc.taskCreate),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
