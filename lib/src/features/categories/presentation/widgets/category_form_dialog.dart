
import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';

class CategoryFormResult {
  const CategoryFormResult({
    required this.name,
    required this.colorValue,
  });

  final String name;
  final int colorValue;
}

class CategoryFormDialog extends StatefulWidget {
  const CategoryFormDialog({
    super.key,
    this.category,
  });

  final CategoryEntity? category;

  @override
  State<CategoryFormDialog> createState() =>
      _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late int _selectedColor;

  static const _colors = [
    0xFF7160BB,
    0xFF398AB4,
    0xFFD7728C,
    0xFF4E9D74,
    0xFFE4A74E,
    0xFF8A7AAB,
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.category?.name ?? '',
    );

    _selectedColor =
        widget.category?.colorValue ?? _colors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    debugPrint('[CategoryForm] Submit');

    if (!_formKey.currentState!.validate()) {
      debugPrint('[CategoryForm] Validation failed');
      return;
    }

    final name = _nameController.text.trim();

    debugPrint('[CategoryForm] Validation success');
    debugPrint('[CategoryForm] Name: $name');

    Navigator.of(context).pop(
      CategoryFormResult(
        name: name,
        colorValue: _selectedColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null
            ? 'Thêm danh mục'
            : 'Chỉnh sửa danh mục',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: false,
                maxLength: 50,
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
                      _selectedColor == colorValue;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = colorValue;
                      });
                    },
                    borderRadius: BorderRadius.circular(24),
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
