import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/comment_model.dart';

final commentsProvider = FutureProvider.autoDispose
    .family<List<CommentModel>, String>((ref, blogId) async {
      final commentSnaps = await FirebaseFirestore.instance
          .collection('blogs')
          .doc(blogId)
          .collection('comments')
          .get();

      final data = commentSnaps.docs;
      return data.map((e) => CommentModel.fromDoc(e)).toList();
    });
