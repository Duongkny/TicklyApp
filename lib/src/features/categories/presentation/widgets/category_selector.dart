import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
    this.enabled = true,
  });

  final String? selectedCategoryId;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryViewStatus.initial ||
            state.status == CategoryViewStatus.loading) {
          return ListTile(
            leading: Icon(Icons.folder_outlined),
            title: Text(context.loc.categoriesLoading),
            trailing: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.status == CategoryViewStatus.failure) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.loc.categoryLoadFailed),
              TextButton.icon(
                onPressed: () =>
                    context.read<CategoryBloc>().add(const CategoryStarted()),
                icon: const Icon(Icons.refresh),
                label: Text(context.loc.commonRetry),
              ),
            ],
          );
        }

        final categories = state.categories;
        final exists = categories.any(
          (category) => category.id == selectedCategoryId,
        );

        final dropdownValue = exists ? selectedCategoryId : '';

        return DropdownButtonFormField<String>(
          key: ValueKey(dropdownValue),
          initialValue: dropdownValue,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: context.loc.categoriesTitle,
            prefixIcon: Icon(Icons.folder_outlined),
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem<String>(
              value: '',
              child: Text(context.loc.categoryNone),
            ),
            ...categories.map(
              (category) => DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(category.colorValue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: enabled
              ? (value) =>
                    onChanged(value == null || value.isEmpty ? null : value)
              : null,
        );
      },
    );
  }
}
