import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/models/post.dart';

final postProvider = FutureProvider<List<Post>>((ref) async {
  final queryPost = await FirebaseFirestore.instance.collection('blogs').get();
  final posts = queryPost.docs;
  return posts.map(((e) => Post.fromFirestore(e))).toList();
});
