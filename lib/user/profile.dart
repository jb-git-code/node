import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/count_provider.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/feed/views/users_screen.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/features/nodes/views/saved_nodes.dart';
import 'package:node/shared/widgets/profile_card.dart';
import 'package:node/shared/widgets/theme_slider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<String> tabs = ['Settings', 'Connect', 'About'];

  // // @override
  // void initState() {
  //   super.initState();

  //   // Add a post-frame callback to safely invalidate providers immediately after the page loads
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.invalidate(createdPostsCountProvider);
  //     ref.invalidate(savedPostsCountProvider);
  //     ref.invalidate(totalStarsEarnedProvider);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final createdCountAsync = ref.watch(createdPostsCountProvider);
    final savedCountAsync = ref.watch(savedPostsCountProvider);
    final userAsync = ref.watch(currentUserProvider);
    final totalStarsAsync = ref.watch(totalStarsEarnedProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('Profile')),
          body: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                CompletionProfileCard(
                  email: user!.email,
                  name: user.name,
                  handle: user.name,
                  createdCountAsync: createdCountAsync,
                  savedCountAsync: savedCountAsync,
                  totalStarsAsync: totalStarsAsync,
                ),
                const SizedBox(height: 40),
                // Profile Data
                GestureDetector(
                  onTap: () {
                    // navigation to joined clusters page
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .90,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Icon(
                          LucideIcons.network,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Joined Clusters',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsersScreen()),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .90,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Icon(
                          LucideIcons.network,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Edges',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SavedNodes()),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .90,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Icon(
                          LucideIcons.bookmark,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Saved Nodes',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: ((error, stackTrace) => Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
