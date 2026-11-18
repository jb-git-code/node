import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/constants/navigation.dart';
import 'package:node/core/constants/skills.dart';
import 'package:node/features/clusters/views/joined_clusters_screen.dart';
import 'package:node/features/feed/providers/count_provider.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/feed/views/connections.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/features/nodes/views/saved_nodes.dart';
import 'package:node/shared/widgets/chip_picker.dart';
import 'package:node/shared/widgets/profile_card.dart';

enum LoadState { loading, loaded, failed }

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<String> tabs = ['Settings', 'Connect', 'About'];
  LoadState _loadState = LoadState.loading;
  bool _updatingRoles = false;
  bool _updatingSkills = false;
  Future<void> _loadRolesAndSkills() async {
    if (mounted) {
      setState(() {
        _loadState = LoadState.loading;
      });
    }
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = doc.data() ?? {};
      if (!mounted) return;
      setState(() {
        selectedRoles = List<String>.from(data['primaryRoles'] ?? []);
        selectedSkills = List<String>.from(data['skills'] ?? []);
        _loadState = LoadState.loaded;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadState = LoadState.failed;
        });
      }
      throw e.toString();
    }
  }

  void _updateRoles() async {
    setState(() {
      _updatingRoles = true;
    });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('No User Found');
      final ref = FirebaseFirestore.instance.collection('users').doc(uid);
      await ref.update({'primaryRoles': selectedRoles});
      setState(() {
        _updatingRoles = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Roles Updated'),
          backgroundColor: Colors.blueAccent,
          duration: Duration(milliseconds: 500),
        ),
      );
    } on FirebaseException catch (_) {
      if (mounted) {
        setState(() {
          _updatingRoles = false;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update Failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _updateSkills() async {
    setState(() {
      _updatingSkills = true;
    });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('No User Found');
      final ref = FirebaseFirestore.instance.collection('users').doc(uid);
      await ref.update({'skills': selectedSkills});
      setState(() {
        _updatingSkills = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Skills Updated'),
          backgroundColor: Colors.blueAccent,
          duration: Duration(milliseconds: 500),
        ),
      );
    } on FirebaseException catch (_) {
      if (mounted) {
        setState(() {
          _updatingSkills = false;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update Failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRolesAndSkills();
  }

  late List<String> selectedRoles = [];
  late List<String> selectedSkills = [];
  bool _isRedirecting = false;
  @override
  Widget build(BuildContext context) {
    final createdCountAsync = ref.watch(createdPostsCountProvider);
    final savedCountAsync = ref.watch(savedPostsCountProvider);
    final userAsync = ref.watch(currentUserProvider);
    final totalStarsAsync = ref.watch(totalStarsEarnedProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) {
          if (!_isRedirecting) {
            _isRedirecting = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            });
          }
        }
        return Scaffold(
          appBar: AppBar(title: Text('Profile')),
          body: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                  switch (_loadState) {
                    LoadState.loading => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    LoadState.failed => Column(
                      children: [
                        const Text("Couldn't load your skills."),
                        TextButton(
                          onPressed: _loadRolesAndSkills,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                    LoadState.loaded => Column(
                      children: [
                        Row(
                          children: [
                            Text('Select Roles '),
                            Spacer(),
                            Text('Selected  ${selectedRoles.length} / 2'),
                            Spacer(),
                            SizedBox(
                              height: 35,
                              width: 40,
                              child: (_updatingRoles)
                                  ? Center(
                                      child: const CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.upload,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: _updateRoles,
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ChipPicker(
                          options: kRolesOptions,
                          selected: selectedRoles,
                          max: 2,
                          onChanged: (value) {
                            setState(() {
                              selectedRoles = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Select Skills '),
                            Spacer(),
                            Text('Selected  ${selectedSkills.length} / 10'),
                            Spacer(),
                            SizedBox(
                              height: 35,
                              width: 40,
                              child: (_updatingSkills)
                                  ? Center(
                                      child: const CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.upload),
                                      onPressed: _updateSkills,
                                      color: Colors.blueAccent,
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ChipPicker(
                          options: kSkills,
                          selected: selectedSkills,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              selectedSkills = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  },

                  // joined clusters
                  if (kClustersScreen)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinedClustersScreen(),
                          ),
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
                              LucideIcons.cuboid,
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
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't load your profile."),
              TextButton(
                onPressed: () => ref.invalidate(currentUserProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
