import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

final class CategoryStarted extends CategoryEvent {
  const CategoryStarted();
}

final class CategoryStopped extends CategoryEvent {
  const CategoryStopped();
}

final class CategoryItemsUpdated extends CategoryEvent {
  const CategoryItemsUpdated(this.categories);

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

final class CategorySubscriptionFailed extends CategoryEvent {
  const CategorySubscriptionFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CategoryCreateRequested extends CategoryEvent {
  const CategoryCreateRequested(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

final class CategoryUpdateRequested extends CategoryEvent {
  const CategoryUpdateRequested(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

final class CategoryDeleteRequested extends CategoryEvent {
  const CategoryDeleteRequested(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class CategoryActionCleared extends CategoryEvent {
  const CategoryActionCleared();
}
