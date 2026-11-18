import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:node/shared/models/post.dart';

class PostRepo {
  static final _db = FirebaseFirestore.instance.collection('blogs');

  static Future<Post?> getPostById(String nodeId) async {
    final doc = await _db.doc(nodeId).get();
    if (!doc.exists) return null;
    return Post.fromFirestore(doc);
  }
}
