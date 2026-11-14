import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node/shared/models/post.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final blogQueryProvider = StateProvider<String?>((ref) => null);

final filterListProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final postAsync = ref.watch(postProvider);

  return postAsync.whenData((posts) {
    if (selectedCategory == null || selectedCategory.isEmpty) return posts;
    return posts.where((e) => e.category == selectedCategory).toList();
  });
});

final postProvider = StreamProvider<List<Post>>((ref) {
  final snaps = FirebaseFirestore.instance.collection('blogs').snapshots();
  return snaps.map((snapshot) {
    return snapshot.docs.map((e) => Post.fromFirestore(e)).toList();
  });
});

final filterBlogsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final blogQuery = ref.watch(blogQueryProvider);
  final postAsync = ref.watch(postProvider);
  return postAsync.whenData((value) {
    if (blogQuery == null) return value;
    return value
        .where(
          (e) =>
              e.title.toLowerCase().contains(blogQuery.toLowerCase()) ||
              e.description.toLowerCase().contains(blogQuery.toLowerCase()),
        )
        .toList();
  });
});
