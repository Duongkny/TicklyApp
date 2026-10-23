import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.colorValue,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;

  // Màu lưu ở dạng ARGB integer, ví dụ 0xFF7160BB.
  final int colorValue;

  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    colorValue,
    createdAt,
    updatedAt,
  ];
}
