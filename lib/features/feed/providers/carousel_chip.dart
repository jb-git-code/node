import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/filter_provider.dart';

class CarouselChip extends ConsumerWidget {
  final String label;
  final FieldCategories category;
  final FieldCategories selectedCategory;

  const CarouselChip({
    required this.label,
    required this.category,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = category == selectedCategory;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            ref.read(feedCategoryProvider.notifier).state = category;
          }
        },
        selectedColor: const Color(0xFFA2D788),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
