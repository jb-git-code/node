import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/features/feed/providers/posts_provider.dart';

enum FieldCategories { latest, trending, topCreators }

final feedCategoryProvider = StateProvider<FieldCategories>(
  (ref) => FieldCategories.latest,
);

final feedProvider = Provider<AsyncValue<dynamic>>((ref) {
  final category = ref.watch(feedCategoryProvider);
  final postAsync = ref.watch(postProvider);

  return postAsync.whenData((posts) {
    switch (category) {
      // latest nodes
      case FieldCategories.latest:
        final latest = List<Post>.from(posts);
        latest.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return latest; // sublist when poss
      // most starred nodes
      case FieldCategories.trending:
        final trending = List<Post>.from(posts);
        trending.sort(
          (a, b) => b.isStarredBy.length.compareTo(a.isStarredBy.length),
        );
        return trending; // sublist when poss
      // creators with most stars
      case FieldCategories.topCreators:
        final Map<String, int> creatorStars = {};
        for (final p in posts) {
          creatorStars[p.authorName] =
              (creatorStars[p.authorName] ?? 0) + p.isStarredBy.length;
        }
        final sortedCreators = creatorStars.entries.toList();
        sortedCreators.sort((a, b) => b.value.compareTo(a.value));
        return sortedCreators; // sublist when poss
    }
  });
});
