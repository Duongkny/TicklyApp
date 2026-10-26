import 'package:tickly/src/core/extensions/context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/category_form_dialog.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, this.onCategorySelected});
  final ValueChanged<String?>? onCategorySelected;

  // ==================== OPEN CATEGORY FORM ====================

  Future<void> _openForm(
    BuildContext context, {
    CategoryEntity? category,
  }) async {
    final bloc = context.read<CategoryBloc>();

    // Không mở form khi đang thực hiện thao tác CRUD.
    if (bloc.state.actionStatus == CategoryActionStatus.loading) {
      return;
    }

    debugPrint('[Category] Mở form danh mục');

    // Xóa trạng thái thao tác trước đó.
    bloc.add(const CategoryActionCleared());

    // Mở Dialog thêm hoặc sửa danh mục.
    final result = await showDialog<CategoryFormResult>(
      context: context,
      builder: (dialogContext) {
        return CategoryFormDialog(category: category);
      },
    );

    debugPrint('[Category] Dialog đã đóng');

    // Người dùng nhấn Hủy hoặc màn hình không còn tồn tại.
    if (result == null || !context.mounted || bloc.isClosed) {
      debugPrint('[Category] Hủy thao tác');
      return;
    }

    // Lấy tài khoản Firebase hiện tại.
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.signInRequired)));
      return;
    }

    final now = DateTime.now();

    // Tạo entity từ thông tin người dùng nhập.
    final entity = CategoryEntity(
      id: category?.id ?? '',
      userId: user.uid,
      name: result.name,
      colorValue: result.colorValue,
      createdAt: category?.createdAt ?? now,
      updatedAt: now,
    );

    // ==================== CREATE ====================

    if (category == null) {
      debugPrint('[Category] Gửi CategoryCreateRequested');

      bloc.add(CategoryCreateRequested(entity));
    }
    // ==================== UPDATE ====================
    else {
      debugPrint('[Category] Gửi CategoryUpdateRequested');

      bloc.add(CategoryUpdateRequested(entity));
    }
  }

  // ==================== DELETE CATEGORY ====================

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    CategoryEntity category,
  ) async {
    final bloc = context.read<CategoryBloc>();

    if (bloc.isClosed ||
        bloc.state.actionStatus == CategoryActionStatus.loading) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.loc.categoryDeleteTitle),
        content: Text(context.loc.categoryDeleteConfirmation(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            child: Text(context.loc.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true ||
        !context.mounted ||
        bloc.isClosed ||
        bloc.state.actionStatus == CategoryActionStatus.loading) {
      return;
    }

    bloc.add(CategoryDeleteRequested(category.id));
  }

  // ==================== CATEGORY ITEM ====================

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryEntity category, {
    required bool isLoading,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        // Biểu tượng danh mục.
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Color(category.colorValue),
          child: const Icon(Icons.folder_rounded, color: Colors.white),
        ),

        // Tên danh mục.
        title: Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        subtitle: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) => Text(
            context.loc.taskCount(
              state.tasks
                  .where((task) => task.categoryId == category.id)
                  .length,
            ),
          ),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: context.loc.categoryEdit,
              onPressed: isLoading
                  ? null
                  : () => _openForm(context, category: category),
              icon: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            IconButton(
              tooltip: context.loc.categoryDelete,
              onPressed: isLoading
                  ? null
                  : () => _confirmDeleteCategory(context, category),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
              ),
            ),
          ],
        ),

        // Mở form chỉnh sửa.
        onTap: isLoading
            ? null
            : () {
                if (onCategorySelected != null) {
                  onCategorySelected!(category.id);
                } else {
                  _openForm(context, category: category);
                }
              },
      ),
    );
  }

  // ==================== EMPTY STATE ====================

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              context.loc.categoryEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.loc.categoryEmptyDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.loc.categoryCreate),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ERROR STATE ====================

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.categoryLoadFailed,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? context.loc.authUnknownError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                context.read<CategoryBloc>().add(const CategoryStarted());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.loc.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ==================== APP BAR ====================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.loc.categoriesTitle),
        backgroundColor: colorScheme.surface,
        centerTitle: false,
      ),

      // ==================== ADD BUTTON ====================
      floatingActionButton: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            previous.actionStatus != current.actionStatus,
        builder: (context, state) {
          final isLoading = state.actionStatus == CategoryActionStatus.loading;

          return FloatingActionButton.extended(
            onPressed: isLoading ? null : () => _openForm(context),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.loc.categoryAdd),
          );
        },
      ),

      // ==================== CATEGORY LIST ====================
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) {
          return previous.actionStatus != current.actionStatus &&
              (current.actionStatus == CategoryActionStatus.success ||
                  current.actionStatus == CategoryActionStatus.failure);
        },

        // Lắng nghe kết quả Create / Update / Delete.
        listener: (context, state) {
          if (state.actionStatus == CategoryActionStatus.success) {
            final message = switch (state.action) {
              CategoryAction.create => context.loc.categoryCreated,
              CategoryAction.update => context.loc.categoryUpdated,
              CategoryAction.delete => context.loc.categoryDeleted,
              CategoryAction.none => context.loc.actionSuccess,
            };

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }

          if (state.actionStatus == CategoryActionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? context.loc.actionFailed),
              ),
            );
          }
        },

        builder: (context, state) {
          // ==================== LOADING ====================

          if (state.status == CategoryViewStatus.initial ||
              state.status == CategoryViewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ==================== ERROR ====================

          if (state.status == CategoryViewStatus.failure) {
            return _buildErrorState(context, state.errorMessage);
          }

          // ==================== EMPTY ====================

          if (state.categories.isEmpty) {
            return _buildEmptyState(context);
          }

          // ==================== LIST ====================

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, tasks) => ListTile(
                      leading: const Icon(Icons.all_inbox_outlined),
                      title: Text(context.loc.allTasks),
                      trailing: Text('${tasks.totalTasks}'),
                      onTap: () => onCategorySelected?.call(null),
                    ),
                  ),
                );
              }
              final category = state.categories[index - 1];

              final isLoading =
                  state.actionStatus == CategoryActionStatus.loading;
              return _buildCategoryItem(
                context,
                category,
                isLoading: isLoading,
              );
            },
          );
        },
      ),
    );
  }
}
