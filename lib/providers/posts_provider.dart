import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node/models/post.dart';

final postProvider = FutureProvider<List<Post>>((ref) async {
  final queryPost = await FirebaseFirestore.instance.collection('blogs').get();
  final posts = queryPost.docs;
  return posts.map(((e) => Post.fromFirestore(e))).toList();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filterListProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final postAsync = ref.watch(postProvider);

  return postAsync.whenData((posts) {
    if (selectedCategory == null || selectedCategory.isEmpty) return posts;
    return posts.where((e) => e.category == selectedCategory).toList();
  });
});
