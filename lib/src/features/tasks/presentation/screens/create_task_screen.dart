import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/features/categories/presentation/widgets/category_selector.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_event.dart';
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
      ).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập')));
      return;
    }

    // Kiểm tra danh mục trước khi lưu.
    final categoryState = context.read<CategoryBloc>().state;

    String? selectedCategoryId;

    if (_categoryId != null) {
      if (categoryState.status != CategoryViewStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chưa thể xác nhận danh mục đã chọn')),
        );
        return;
      }

      final exists = categoryState.categories.any(
        (category) => category.id == _categoryId,
      );

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Danh mục đã chọn không còn tồn tại')),
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

      priority: _priority,
      status: TaskStatus.pending,
      dueDate: _dueDate,
      createdAt: now,
      updatedAt: now,
    );

    context.read<TaskBloc>().add(TaskCreateRequested(task));
  }

  // ==================== CATEGORY DROPDOWN ====================

  Widget _buildCategoryDropdown() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Đang tải danh mục.
        if (state.status == CategoryViewStatus.initial ||
            state.status == CategoryViewStatus.loading) {
          return const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.folder_outlined),
            title: Text('Đang tải danh mục...'),
            trailing: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        // Không thể tải danh mục.
        if (state.status == CategoryViewStatus.failure) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Không thể tải danh mục'),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  context.read<CategoryBloc>().add(const CategoryStarted());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          );
        }

        final categories = state.categories;

        // Dropdown chỉ nhận ID đang tồn tại.
        final selectedId =
            categories.any((category) => category.id == _categoryId)
            ? _categoryId
            : null;

        return DropdownButtonFormField<String>(
          key: ValueKey(selectedId ?? 'no-category'),
          initialValue: selectedId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Danh mục',
            hintText: 'Chọn danh mục',
            prefixIcon: Icon(Icons.folder_outlined),
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: '',
              child: Text('Không có danh mục'),
            ),

            ...categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(category.colorValue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _categoryId = value == null || value.isEmpty ? null : value;
            });
          },
        );
      },
    );
  }

  // ==================== BUILD ====================

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
              content: Text(state.errorMessage ?? 'Không thể tạo công việc'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: const Text('Tạo công việc'),
          backgroundColor: colors.surface,
        ),

        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ==================== TITLE ====================
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

                // ==================== DESCRIPTION ====================
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

                // ==================== CATEGORY ====================
                Text(
                  'Danh mục',
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
                  'Mức độ ưu tiên',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

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

                // ==================== DUE DATE ====================
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
                            setState(() {
                              _dueDate = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                  onTap: _selectDueDate,
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
