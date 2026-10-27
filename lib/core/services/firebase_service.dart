import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<void> toggleSave(String psid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final postRef = FirebaseFirestore.instance.collection('blogs').doc(psid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) return null;
        final data = snapshot.data() ?? {};
        final List<dynamic> savedByList = List<dynamic>.from(
          data['isSavedBy'] ?? [],
        );

        final bool alreadySaved = savedByList.contains(user.uid);

        transaction.update(postRef, {
          'isSavedBy': alreadySaved
              ? FieldValue.arrayRemove([user.uid])
              : FieldValue.arrayUnion([user.uid]),
        });
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> toggleStars(String psid, bool isStarred) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final postRef = FirebaseFirestore.instance.collection('blogs').doc(psid);

    try {
      await postRef.update({
        'isStarredBy': (isStarred)
            ? FieldValue.arrayRemove([user.uid])
            : FieldValue.arrayUnion([user.uid]),
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
