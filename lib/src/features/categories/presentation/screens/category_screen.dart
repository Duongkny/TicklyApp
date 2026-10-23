
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const _colors = <int>[
    0xFF7160BB,
    0xFF398AB4,
    0xFFD7728C,
    0xFF4E9D74,
    0xFFE4A74E,
    0xFF8A7AAB,
  ];

  Future<void> _openForm(
    BuildContext context, {
    CategoryEntity? category,
  }) async {
    final nameController = TextEditingController(
      text: category?.name ?? '',
    );

    var selectedColor = category?.colorValue ?? _colors.first;
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<CategoryEntity>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return AlertDialog(
                title: Text(
                  category == null
                      ? 'Thêm danh mục'
                      : 'Chỉnh sửa danh mục',
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          maxLength: 50,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Tên danh mục',
                            hintText: 'Ví dụ: Học tập',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Vui lòng nhập tên danh mục';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        const Text('Chọn màu'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _colors.map((colorValue) {
                            final selected =
                                selectedColor == colorValue;

                            return InkWell(
                              onTap: () {
                                setDialogState(() {
                                  selectedColor = colorValue;
                                });
                              },
                              borderRadius:
                                  BorderRadius.circular(24),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(colorValue),
                                child: selected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    child: const Text('Hủy'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final user =
                          FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng đăng nhập'),
                          ),
                        );
                        return;
                      }

                      final now = DateTime.now();

                      final result = CategoryEntity(
                        id: category?.id ?? '',
                        userId: category?.userId ?? user.uid,
                        name: nameController.text.trim(),
                        colorValue: selectedColor,
                        createdAt: category?.createdAt ?? now,
                        updatedAt: now,
                      );

                      Navigator.pop(dialogContext, result);
                    },
                    child: const Text('Lưu'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result == null || !context.mounted) return;

      final bloc = context.read<CategoryBloc>();

      if (category == null) {
        bloc.add(CategoryCreateRequested(result));
      } else {
        bloc.add(CategoryUpdateRequested(result));
      }
    } finally {
      // Chỉ giải phóng sau khi hộp thoại đã đóng.
      nameController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Danh mục của tôi'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final state = context.read<CategoryBloc>().state;

          if (state.actionStatus ==
              CategoryActionStatus.loading) {
            return;
          }

          _openForm(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm danh mục'),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) =>
            previous.actionStatus != current.actionStatus &&
            current.actionStatus !=
                CategoryActionStatus.initial,
        listener: (context, state) {
          if (state.actionStatus ==
              CategoryActionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã lưu danh mục thành công'),
              ),
            );
          } else if (state.actionStatus ==
              CategoryActionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Thao tác không thành công',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CategoryViewStatus.initial ||
              state.status == CategoryViewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == CategoryViewStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không thể tải danh mục'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(
                        const CategoryStarted(),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 72,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text('Bạn chưa có danh mục nào'),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhấn Thêm danh mục để bắt đầu',
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Color(category.colorValue),
                    child: const Icon(
                      Icons.folder,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(category.name),
                  subtitle: const Text('Nhấn để chỉnh sửa'),
                  trailing: const Icon(
                    Icons.edit_outlined,
                  ),
                  onTap: state.actionStatus ==
                          CategoryActionStatus.loading
                      ? null
                      : () => _openForm(
                            context,
                            category: category,
                          ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
