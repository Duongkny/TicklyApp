import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(
    this._createCategory,
    this._getCategories,
    this._updateCategory,
    this._deleteCategory,
  ) : super(const CategoryState()) {
    on<CategoryStarted>(_onStarted);
    on<CategoryStopped>(_onStopped);
    on<CategoryItemsUpdated>(_onItemsUpdated);
    on<CategorySubscriptionFailed>(_onSubscriptionFailed);

    on<CategoryCreateRequested>(_onCreate);
    on<CategoryUpdateRequested>(_onUpdate);
    on<CategoryDeleteRequested>(_onDelete);
    on<CategoryActionCleared>(_onActionCleared);
  }

  final CreateCategory _createCategory;
  final GetCategories _getCategories;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  StreamSubscription<List<CategoryEntity>>? _subscription;
  int _watchGeneration = 0;

  Future<void> _onStarted(
    CategoryStarted event,
    Emitter<CategoryState> emit,
  ) async {
    final generation = ++_watchGeneration;

    await _subscription?.cancel();
    _subscription = null;

    emit(
      state.copyWith(
        status: CategoryViewStatus.loading,
        categories: const [],
        clearError: true,
      ),
    );

    try {
      _subscription = _getCategories().listen(
        (categories) {
          if (!isClosed && generation == _watchGeneration) {
            add(CategoryItemsUpdated(categories));
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('Category Firestore error: $error');
          debugPrintStack(stackTrace: stackTrace);

          if (!isClosed && generation == _watchGeneration) {
            add(
              const CategorySubscriptionFailed(
                'Không thể tải danh mục từ Firestore.',
              ),
            );
          }
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CategoryViewStatus.failure,
          errorMessage: 'Không thể kết nối Firestore: $error',
        ),
      );
    }
  }

  Future<void> _onStopped(
    CategoryStopped event,
    Emitter<CategoryState> emit,
  ) async {
    ++_watchGeneration;
    await _subscription?.cancel();
    _subscription = null;
    emit(const CategoryState());
  }

  void _onItemsUpdated(
    CategoryItemsUpdated event,
    Emitter<CategoryState> emit,
  ) {
    if (_subscription == null) return;

    emit(
      state.copyWith(
        status: CategoryViewStatus.success,
        categories: event.categories,
        clearError: true,
      ),
    );
  }

  void _onSubscriptionFailed(
    CategorySubscriptionFailed event,
    Emitter<CategoryState> emit,
  ) {
    if (_subscription == null) return;

    emit(
      state.copyWith(
        status: CategoryViewStatus.failure,
        errorMessage: event.message,
      ),
    );
  }

  Future<void> _onCreate(
    CategoryCreateRequested event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.actionStatus == CategoryActionStatus.loading) return;

    emit(
      state.copyWith(
        action: CategoryAction.create,
        actionStatus: CategoryActionStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _createCategory(event.category);

      emit(
        state.copyWith(
          action: CategoryAction.create,
          actionStatus: CategoryActionStatus.success,
        ),
      );
    } catch (error) {
      debugPrint('Create category error: $error');
      emit(
        state.copyWith(
          action: CategoryAction.create,
          actionStatus: CategoryActionStatus.failure,
          errorMessage: 'Không thể tạo danh mục.',
        ),
      );
    }
  }

  Future<void> _onUpdate(
    CategoryUpdateRequested event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.actionStatus == CategoryActionStatus.loading) return;

    emit(
      state.copyWith(
        action: CategoryAction.update,
        actionStatus: CategoryActionStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _updateCategory(event.category);

      emit(
        state.copyWith(
          action: CategoryAction.update,
          actionStatus: CategoryActionStatus.success,
        ),
      );
    } catch (error) {
      debugPrint('Update category error: $error');
      emit(
        state.copyWith(
          action: CategoryAction.update,
          actionStatus: CategoryActionStatus.failure,
          errorMessage: 'Không thể cập nhật danh mục.',
        ),
      );
    }
  }

  Future<void> _onDelete(
    CategoryDeleteRequested event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.actionStatus == CategoryActionStatus.loading) return;

    emit(
      state.copyWith(
        action: CategoryAction.delete,
        actionStatus: CategoryActionStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _deleteCategory(event.categoryId);

      emit(
        state.copyWith(
          action: CategoryAction.delete,
          actionStatus: CategoryActionStatus.success,
        ),
      );
    } catch (error) {
      debugPrint('Delete category error: $error');
      emit(
        state.copyWith(
          action: CategoryAction.delete,
          actionStatus: CategoryActionStatus.failure,
          errorMessage: 'Không thể xóa danh mục.',
        ),
      );
    }
  }

  void _onActionCleared(
    CategoryActionCleared event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.copyWith(
        action: CategoryAction.none,
        actionStatus: CategoryActionStatus.initial,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    ++_watchGeneration;
    await _subscription?.cancel();
    await super.close();
  }
}
