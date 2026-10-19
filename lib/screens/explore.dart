import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> _categories = ["Tech", "Placement", "Share", "Exp"];
  String? selectedCategory;
  void _toggleCategory(String cat) {
    setState(() {
      if (selectedCategory == cat) {
        selectedCategory = null;
      } else {
        selectedCategory = cat;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16),
      child: Column(
        children: [
          buildCategories(context),
          const SizedBox(height: 20),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width * .90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.lime,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12.0, // Gap between chips horizontally
            runSpacing: 10.0, // Gap between chips vertically
            children: _categories.map((category) {
              final isSelected = (selectedCategory == category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => _toggleCategory(category),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: const Color(0xFF1E1E1E),
                selectedColor: Colors.lightGreenAccent,
                checkmarkColor: Colors.black,
                showCheckmark: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.lightGreenAccent
                        : Colors.white24,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
