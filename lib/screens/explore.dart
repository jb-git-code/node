import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/models/post.dart';
import 'package:node/providers/posts_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final List<String> _categories = ["Tech", "Placement", "Share", "Exp"];
  // String? selectedCategory;
  List<Post> allPost = [];
  void _toggleCategory(String cat) {
    final current = ref.read(selectedCategoryProvider);
    ref.read(selectedCategoryProvider.notifier).state = (current == cat)
        ? null
        : cat;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filterPosts = ref.watch(filterListProvider);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          buildCategories(context),
          const SizedBox(height: 20),
          filterPosts.when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width * .90,
                          height: 300,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            error: (err, stack) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load: $err'),
                  ElevatedButton(
                    onPressed: () => ref.refresh(filterListProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12.0,
            runSpacing: 10.0,
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
