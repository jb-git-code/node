import 'package:amicons/amicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/count_provider.dart';
import 'package:node/core/themes/providers/theme_provider.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/nodes/saved_nodes.dart';
import 'package:node/shared/widgets/theme_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<String> tabs = ['Settings', 'Connect', 'About'];

  void openAbout() async {
    final url = Uri.parse('https://github.com/jb-git-code/node');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw e.toString();
    }
  }

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
    final user = FirebaseAuth.instance.currentUser;
    final totalStarsAsync = ref.watch(totalStarsEarnedProvider);
    return Padding(
      padding: EdgeInsetsGeometry.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFA2D788),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 250,
            width: MediaQuery.of(context).size.width * .90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // photo + unique ID
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightGreen,
                        ),
                        child: Icon(
                          Amicons.iconly_profile_curved_fill,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('@userID000', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                // account info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.displayName ?? 'Unknown',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user.email ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      createdCountAsync.when(
                        data: (count) =>
                            _StatItem(label: 'Nodes Created', count: count),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => const Text('Error'),
                      ),
                      const SizedBox(height: 15),
                      // Display Saved Count
                      savedCountAsync.when(
                        data: (count) =>
                            _StatItem(label: 'Nodes Saved   ', count: count),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => const Text('Error'),
                      ),
                      const SizedBox(height: 15),
                      totalStarsAsync.when(
                        data: (stars) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Stars Earned       ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              stars.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => const Text('Error loading stars'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ThemeSlider(),
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
                color: Color(0xFFA2D788),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(
                    Amicons.lucide_chart_no_axes_column_decreasing,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Text('Saved Nodes', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: openAbout,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                color: Color(0xFFA2D788),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(Amicons.remix_information, color: Colors.black),
                  const SizedBox(width: 10),
                  Text('About', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (conext) => LoginScreen()),
                (route) => false,
              );
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                color: Color(0xFFA2D788),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(Amicons.remix_login_box, color: Colors.black),
                  const SizedBox(width: 10),
                  Text('Log Out', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
