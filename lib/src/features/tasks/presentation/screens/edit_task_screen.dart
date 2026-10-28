import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/core/notification/reminder_permissions.dart';
import 'package:tickly/src/core/localization/date_formatting.dart';
import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/features/categories/presentation/widgets/category_selector.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});

  final TaskEntity task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late TaskPriority _priority;

  DateTime? _dueDate;
  DateTime? _reminderAt;
  String? _categoryId;

  // ==================== INITIAL STATE ====================

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);

    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );

    _priority = widget.task.priority;
    _categoryId = widget.task.categoryId;
    _dueDate = widget.task.dueDate;
    _reminderAt = widget.task.reminderAt;
  }

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  // ==================== DATE FORMAT ====================

  // ==================== SELECT DUE DATE ====================

  Future<void> _selectDueDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 20),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _dueDate == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(_dueDate!.toLocal()),
    );

    if (time == null || !mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _dueDate = selected;
    });
  }

  // ==================== SELECT REMINDER ====================

  Future<void> _selectReminder() async {
    final now = DateTime.now();

    final initial = _reminderAt != null && _reminderAt!.isAfter(now)
        ? _reminderAt!.toLocal()
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

  // ==================== SAVE TASK ====================

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (_reminderAt != null &&
        !_reminderAt!.isAfter(DateTime.now()) &&
        _reminderAt != widget.task.reminderAt) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.newReminderMustBeFuture)),
      );
      return;
    }

    final updatedTask = TaskEntity(
      id: widget.task.id,
      userId: widget.task.userId,
      title: title,
      description: description.isEmpty ? null : description,
      categoryId: _categoryId,
      priority: _priority,
      status: widget.task.status,
      dueDate: _dueDate,
      reminderAt: _reminderAt,
      completedAt: widget.task.completedAt,
      createdAt: widget.task.createdAt,
      updatedAt: DateTime.now(),
    );

    debugPrint('[EditTask] Saving reminderAt: ${updatedTask.reminderAt}');

    context.read<TaskBloc>().add(TaskUpdateRequested(updatedTask));
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) {
        return current.action == TaskAction.update &&
            previous.actionStatus != current.actionStatus;
      },
      listener: (context, state) {
        if (state.actionStatus == TaskActionStatus.success) {
          Navigator.of(context).pop();
        } else if (state.actionStatus == TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.loc.taskUpdateFailed),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Text(context.loc.taskEdit),
          backgroundColor: colors.surface,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              // ==================== TITLE ====================
              InputField(
                controller: _titleController,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: context.loc.taskTitleLabel,
                  prefixIcon: Icon(Icons.task_alt_outlined),
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
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // ==================== CATEGORY ====================
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
              Text(context.loc.priorityTitle, style: textTheme.titleMedium),

              const SizedBox(height: 12),

              SegmentedButton<TaskPriority>(
                segments: [
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.low,
                    label: Text(context.loc.priorityLow),
                  ),
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.medium,
                    label: Text(context.loc.priorityMedium),
                  ),
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.high,
                    label: Text(context.loc.priorityHigh),
                  ),
                ],
                selected: {_priority},
                onSelectionChanged: (value) {
                  setState(() {
                    _priority = value.first;
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
                        tooltip: context.loc.removeDueDate,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                      ),
                onTap: _selectDueDate,
              ),

              const SizedBox(height: 12),

              // ==================== REMINDER ====================
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
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _reminderAt = null;
                          });
                        },
                      ),
                onTap: _selectReminder,
              ),

              const SizedBox(height: 32),

              // ==================== SAVE BUTTON ====================
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  final isLoading =
                      state.action == TaskAction.update &&
                      state.actionStatus == TaskActionStatus.loading;

                  return FilledButton.icon(
                    onPressed: isLoading ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      isLoading
                          ? context.loc.commonSaving
                          : context.loc.saveChanges,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
