import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';

enum CategoryViewStatus { initial, loading, success, failure }

enum CategoryActionStatus { initial, loading, success, failure }

enum CategoryAction { none, create, update, delete }

class CategoryState extends Equatable {
  const CategoryState({
    this.status = CategoryViewStatus.initial,
    this.actionStatus = CategoryActionStatus.initial,
    this.action = CategoryAction.none,
    this.categories = const [],
    this.errorMessage,
  });

  final CategoryViewStatus status;
  final CategoryActionStatus actionStatus;
  final CategoryAction action;
  final List<CategoryEntity> categories;
  final String? errorMessage;

  CategoryState copyWith({
    CategoryViewStatus? status,
    CategoryActionStatus? actionStatus,
    CategoryAction? action,
    List<CategoryEntity>? categories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      action: action ?? this.action,
      categories: categories ?? this.categories,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    action,
    categories,
    errorMessage,
  ];
}
