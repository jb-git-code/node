import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              final data = docs[index].data();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(title: Text(data['title'] ?? 'No Title')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
