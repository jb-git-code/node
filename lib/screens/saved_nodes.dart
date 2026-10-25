import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:node/models/post.dart';
import 'package:node/widgets/blog_card.dart';
import 'package:node/widgets/expand_blog_card.dart';

class SavedNodes extends StatelessWidget {
  const SavedNodes({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Saved Nodes'), centerTitle: true),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('blogs')
            .where('isSavedBy', arrayContains: user?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No saved posts yet.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      final post = Post.fromFirestore(data);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpandBlogCard(post: post),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(data.data()['title'] ?? 'No Title'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
