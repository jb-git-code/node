import 'package:flutter/material.dart';

class ChipPicker extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final int max;
  final ValueChanged<List<String>> onChanged;

  const ChipPicker({
    super.key,
    required this.options,
    required this.selected,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        runSpacing: 12,
        children: options.map((option) {
          final isSelected = selected.contains(option);
          return FilterChip(
            label: Text(option),
            selected: isSelected,
            selectedColor: Colors.lightGreen,
            checkmarkColor: Theme.of(context).colorScheme.primary,
            onSelected: (value) {
              final updated = List<String>.from(selected);
              if (value) {
                if (updated.length >= max) return; // block extra picks
                updated.add(option);
              } else {
                updated.remove(option);
              }
              onChanged(updated);
            },
          );
        }).toList(),
      ),
    );
  }
}
