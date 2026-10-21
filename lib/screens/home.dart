import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/posts_provider.dart';
import 'package:node/providers/theme_provider.dart';
import 'package:node/widgets/blog_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final postPro = ref.watch(postProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(postProvider);
        await ref.read(postProvider.future);
      },
      child: postPro.when(
        skipLoadingOnRefresh: false,
        data: (post) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'See all the latest nodes',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        final postItem = post[index];
                        return BlogCard(post: postItem);
                      },
                    ),
                  ),
                ],
              ),
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
      ),
    );
  }
}
