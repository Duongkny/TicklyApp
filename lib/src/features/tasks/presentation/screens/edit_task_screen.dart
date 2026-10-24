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
  String? _categoryId;

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final description = _descriptionController.text.trim();

    final updatedTask = TaskEntity(
      id: widget.task.id,
      userId: widget.task.userId,
      title: _titleController.text.trim(),
      description: description.isEmpty ? null : description,
      categoryId: _categoryId,
      priority: _priority,
      status: widget.task.status,
      dueDate: _dueDate,
      reminderAt: widget.task.reminderAt,
      createdAt: widget.task.createdAt,
      updatedAt: DateTime.now(),
    );

    context.read<TaskBloc>().add(TaskUpdateRequested(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          current.action == TaskAction.update &&
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == TaskActionStatus.success) {
          Navigator.of(context).pop();
        } else if (state.actionStatus == TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Không thể cập nhật công việc',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Chỉnh sửa công việc')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Tên công việc',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên công việc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              CategorySelector(
                selectedCategoryId: _categoryId,
                onChanged: (categoryId) {
                  setState(() {
                    _categoryId = categoryId;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Mức độ ưu tiên',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SegmentedButton<TaskPriority>(
                segments: const [
                  ButtonSegment(value: TaskPriority.low, label: Text('Thấp')),
                  ButtonSegment(value: TaskPriority.medium, label: Text('Vừa')),
                  ButtonSegment(value: TaskPriority.high, label: Text('Cao')),
                ],
                selected: {_priority},
                onSelectionChanged: (value) {
                  setState(() => _priority = value.first);
                },
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: colors.primary,
                ),
                title: const Text('Hạn hoàn thành'),
                subtitle: Text(
                  _dueDate == null
                      ? 'Chưa chọn'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
                onTap: _selectDueDate,
                trailing: _dueDate == null
                    ? const Icon(Icons.chevron_right)
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() => _dueDate = null);
                        },
                      ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  final loading =
                      state.action == TaskAction.update &&
                      state.actionStatus == TaskActionStatus.loading;

                  return FilledButton(
                    onPressed: loading ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Lưu thay đổi'),
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
