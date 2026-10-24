
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/category_form_dialog.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // ==================== OPEN CATEGORY FORM ====================

  Future<void> _openForm(
    BuildContext context, {
    CategoryEntity? category,
  }) async {
    final bloc = context.read<CategoryBloc>();

    // Không mở form khi đang thực hiện thao tác CRUD.
    if (bloc.state.actionStatus ==
        CategoryActionStatus.loading) {
      return;
    }

    debugPrint('[Category] Mở form danh mục');

    // Xóa trạng thái thao tác trước đó.
    bloc.add(const CategoryActionCleared());

    // Mở Dialog thêm hoặc sửa danh mục.
    final result = await showDialog<CategoryFormResult>(
      context: context,
      builder: (dialogContext) {
        return CategoryFormDialog(
          category: category,
        );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập'),
        ),
      );
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
      debugPrint(
        '[Category] Gửi CategoryCreateRequested',
      );

      bloc.add(
        CategoryCreateRequested(entity),
      );
    }

    // ==================== UPDATE ====================

    else {
      debugPrint(
        '[Category] Gửi CategoryUpdateRequested',
      );

      bloc.add(
        CategoryUpdateRequested(entity),
      );
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
        title: const Text('Xóa danh mục?'),
        content: Text(
          'Bạn có chắc muốn xóa "${category.name}"?\n\n'
          'Các công việc trong danh mục này sẽ được giữ lại và '
          'chuyển sang "Chưa phân loại".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted || bloc.isClosed ||
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
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        // Biểu tượng danh mục.
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Color(category.colorValue),
          child: const Icon(
            Icons.folder_rounded,
            color: Colors.white,
          ),
        ),

        // Tên danh mục.
        title: Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),

        subtitle: const Text(
          'Nhấn để chỉnh sửa',
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Chỉnh sửa danh mục',
              onPressed: isLoading
                  ? null
                  : () => _openForm(context, category: category),
              icon: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            IconButton(
              tooltip: 'Xóa danh mục',
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
                _openForm(
                  context,
                  category: category,
                );
              },
      ),
    );
  }

  // ==================== EMPTY STATE ====================

  Widget _buildEmptyState(
    BuildContext context,
  ) {
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
              'Bạn chưa có danh mục nào',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy tạo danh mục đầu tiên để '
              'sắp xếp công việc dễ dàng hơn.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tạo danh mục'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ERROR STATE ====================

  Widget _buildErrorState(
    BuildContext context,
    String? errorMessage,
  ) {
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
              'Không thể tải danh mục',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ??
                  'Đã xảy ra lỗi. Vui lòng thử lại.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                context.read<CategoryBloc>().add(
                  const CategoryStarted(),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
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
        title: const Text('Danh mục của tôi'),
        backgroundColor: colorScheme.surface,
        centerTitle: false,
      ),

      // ==================== ADD BUTTON ====================

      floatingActionButton:
          BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            previous.actionStatus !=
            current.actionStatus,
        builder: (context, state) {
          final isLoading =
              state.actionStatus ==
              CategoryActionStatus.loading;

          return FloatingActionButton.extended(
            onPressed: isLoading
                ? null
                : () => _openForm(context),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm danh mục'),
          );
        },
      ),

      // ==================== CATEGORY LIST ====================

      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) {
          return previous.actionStatus !=
                  current.actionStatus &&
              (current.actionStatus ==
                      CategoryActionStatus.success ||
                  current.actionStatus ==
                      CategoryActionStatus.failure);
        },

        // Lắng nghe kết quả Create / Update / Delete.
        listener: (context, state) {
          if (state.actionStatus ==
              CategoryActionStatus.success) {
            final message = switch (state.action) {
              CategoryAction.create =>
                'Tạo danh mục thành công',
              CategoryAction.update =>
                'Cập nhật danh mục thành công',
              CategoryAction.delete =>
                'Xóa danh mục thành công',
              CategoryAction.none =>
                'Thao tác thành công',
            };

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(content: Text(message)),
            );
          }

          if (state.actionStatus ==
              CategoryActionStatus.failure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
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
          // ==================== LOADING ====================

          if (state.status ==
                  CategoryViewStatus.initial ||
              state.status ==
                  CategoryViewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ==================== ERROR ====================

          if (state.status ==
              CategoryViewStatus.failure) {
            return _buildErrorState(
              context,
              state.errorMessage,
            );
          }

          // ==================== EMPTY ====================

          if (state.categories.isEmpty) {
            return _buildEmptyState(context);
          }

          // ==================== LIST ====================

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category =
                  state.categories[index];

              final isLoading =
                  state.actionStatus ==
                  CategoryActionStatus.loading;

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
