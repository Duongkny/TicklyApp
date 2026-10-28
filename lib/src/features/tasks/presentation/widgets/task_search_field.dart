import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/core/extensions/context.dart';

import 'package:flutter/material.dart';

class TaskSearchField extends StatefulWidget {
  const TaskSearchField({
    super.key,
    required this.query,
    required this.onChanged,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<TaskSearchField> createState() => _TaskSearchFieldState();
}

class _TaskSearchFieldState extends State<TaskSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant TaskSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InputField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.loc.taskSearchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: widget.query.isNotEmpty
            ? IconButton(
                tooltip: context.loc.clearSearch,
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: colors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
