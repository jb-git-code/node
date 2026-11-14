import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/features/feed/providers/posts_provider.dart';
import 'package:node/shared/widgets/blog_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final List<String> _categories = ["Tech", "Placement", "Share", "Exp"];
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
    // final filterPosts = ref.watch(filterListProvider);
    final filterBlogsAsync = ref.watch(filterBlogsProvider);
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        ref.read(blogQueryProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Nodes',
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(LucideIcons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // category filter for blogs
                IconButton(
                  icon: Icon(Icons.filter_list, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // buildCategories(context),
          // const SizedBox(height: 10),
          filterBlogsAsync.when(
            data: (post) {
              return Expanded(
                child: ListView.builder(
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    return BlogCard(
                      key: ValueKey(
                        '${post[index].postId}_${post[index].isStarredBy.length}_${post[index].isSavedBy.length}',
                      ),
                      post: post[index],
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
      padding: const EdgeInsets.only(left: 8),
      child: Wrap(
        spacing: MediaQuery.of(context).size.width * 0.04,
        runSpacing: 10.0,
        children: _categories.map((category) {
          final isSelected = (selectedCategory == category);
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => _toggleCategory(category),
            labelStyle: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            checkmarkColor: !isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            showCheckmark: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }
}
