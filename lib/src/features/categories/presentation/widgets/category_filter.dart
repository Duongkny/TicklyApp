import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  // null: Tất cả
  // '': Chưa phân loại
  // ID khác: danh mục cụ thể
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(context.loc.filterAll),
              selected: selectedCategoryId == null,
              onSelected: (_) => onChanged(null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(context.loc.uncategorized),
              selected: selectedCategoryId == '',
              onSelected: (_) => onChanged(''),
            ),
          ),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                avatar: CircleAvatar(
                  radius: 7,
                  backgroundColor: Color(category.colorValue),
                ),
                label: Text(category.name),
                selected: selectedCategoryId == category.id,
                onSelected: (_) => onChanged(category.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
