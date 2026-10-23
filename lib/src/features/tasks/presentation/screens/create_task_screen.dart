import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập')));
      return;
    }

    final now = DateTime.now();

    final task = TaskEntity(
      id: '',
      userId: user.uid,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
      createdAt: now,
      updatedAt: now,
    );

    context.read<TaskBloc>().add(TaskCreateRequested(task));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus ||
          previous.action != current.action,
      listener: (context, state) {
        if (state.action != TaskAction.create) return;

        if (state.actionStatus == TaskActionStatus.success) {
          Navigator.of(context).pop();
        }

        if (state.actionStatus == TaskActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Không thể tạo công việc'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Tạo công việc')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề công việc',
                    hintText: 'Ví dụ: Học Flutter BLoC',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề';
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
                    hintText: 'Nhập mô tả công việc...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Mức độ ưu tiên',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SegmentedButton<TaskPriority>(
                  segments: const [
                    ButtonSegment(value: TaskPriority.low, label: Text('Thấp')),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text('Vừa'),
                    ),
                    ButtonSegment(value: TaskPriority.high, label: Text('Cao')),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (values) {
                    setState(() {
                      _priority = values.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    color: colors.primary,
                  ),
                  title: const Text('Ngày và giờ hết hạn'),
                  subtitle: Text(
                    _dueDate == null
                        ? 'Chưa chọn'
                        : '${_dueDate!.day.toString().padLeft(2, '0')}/'
                              '${_dueDate!.month.toString().padLeft(2, '0')}/'
                              '${_dueDate!.year} '
                              '${_dueDate!.hour.toString().padLeft(2, '0')}:'
                              '${_dueDate!.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: _dueDate == null
                      ? const Icon(Icons.chevron_right)
                      : IconButton(
                          onPressed: () {
                            setState(() => _dueDate = null);
                          },
                          icon: const Icon(Icons.close),
                        ),
                  onTap: _selectDueDate,
                ),
                const SizedBox(height: 32),
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
                          : const Text('Tạo công việc'),
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
