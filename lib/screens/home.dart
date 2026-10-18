import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/posts_provider.dart';
import 'package:node/providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeValue = ref.watch(darkThemeProvider);
    final postPro = ref.watch(postProvider);
    return postPro.when(
      data: (post) {
        return Scaffold(
          body: ListView.builder(
            itemCount: post.length,
            itemBuilder: (context, index) {
              final postItem = post[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurpleAccent,
                  ),
                  height: 300,
                  width: 350,
                  child: Center(
                    child: Text(
                      postItem.authorName,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (err, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load: $err'),
            ElevatedButton(
              onPressed: () => ref.refresh(postProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
