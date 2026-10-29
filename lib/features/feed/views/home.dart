import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/features/feed/providers/carousel_chip.dart';
import 'package:node/features/feed/providers/filter_provider.dart';
import 'package:node/features/feed/providers/posts_provider.dart';
import 'package:node/core/themes/providers/theme_provider.dart';
import 'package:node/shared/widgets/blog_card.dart';
import 'package:node/shared/widgets/expand_blog_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedProvider);
    final selectedCategory = ref.watch(feedCategoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // carousel
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                CarouselChip(
                  label: 'Latest Nodes',
                  category: FieldCategories.latest,
                  selectedCategory: selectedCategory,
                ),
                CarouselChip(
                  label: 'Trending Nodes',
                  category: FieldCategories.trending,
                  selectedCategory: selectedCategory,
                ),
                CarouselChip(
                  label: 'Top Creators',
                  category: FieldCategories.topCreators,
                  selectedCategory: selectedCategory,
                ),
              ],
            ),
          ),

          // dynamic feed
          Expanded(
            child: feedAsync.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    if (selectedCategory == FieldCategories.topCreators) {
                      final creator = data[index] as MapEntry<String, int>;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(creator.key[0].toUpperCase()),
                        ),
                        title: Text(
                          creator.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${creator.value}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final post = data[index] as Post;
                      return BlogCard(
                        key: ValueKey(
                          '${post.postId}_${post.isStarredBy.length}_${post.isSavedBy.length}',
                        ),
                        post: post,
                      );
                    }
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
