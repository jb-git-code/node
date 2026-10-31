import 'package:amicons/amicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/count_provider.dart';
import 'package:node/features/feed/views/clusters_screen.dart';
import 'package:node/features/feed/views/users_screen.dart';
import 'package:node/features/nodes/views/compose.dart';
import 'package:node/features/feed/views/explore.dart';
import 'package:node/features/feed/views/home.dart';
import 'package:node/features/nodes/views/profile.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  int _currentIndex = 0;

  // @override
  // void initState() {
  //   super.initState();

  //   // Listen for shared media/links while the app is running in memory
  //   ReceiveSharingIntent.instance.getMediaStream().listen((
  //     List<SharedMediaFile> value,
  //   ) {
  //     print("Incoming shared files: ${value.map((f) => f.path).join(",")}");
  //   });

  //   // Handle media/links that launched the app from a closed state
  //   ReceiveSharingIntent.instance.getInitialMedia().then((
  //     List<SharedMediaFile> value,
  //   ) {
  //     if (value.isNotEmpty) {
  //       print("App opened via share: ${value.first.path}");
  //       // Redirect user to the "Create Post" screen with this data
  //     }
  //   });
  // }

  void changeTab(int index) {
    if (index == 3) {
      ref.invalidate(createdPostsCountProvider);
      ref.invalidate(savedPostsCountProvider);
      ref.invalidate(totalStarsEarnedProvider);
    }
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = index;
    });
  }

  void showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Mark all read'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: 8,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.notifications_outlined, size: 20),
                        ),
                        title: Text('Update notification #${index + 1}'),
                        subtitle: const Text('2 hours ago'),
                        onTap: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        title: Text('Node'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              // showNotificationsSheet(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UsersScreen()),
              // );
            },
            icon: Icon(Amicons.iconly_notification_2_sharp_fill),
          ),
        ],
      ),
      body: BottomBar(
        layout: const BottomBarLayout.adaptive(maxWidth: 300),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(),
            ExploreScreen(),
            ComposeBlog(),
            ProfileScreen(),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(28),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                changeTab(index);
              },

              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.lightGreenAccent,
              unselectedItemColor: Colors.white,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Amicons.flaticon_home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Amicons.vuesax_command_square_fill),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Amicons.flaticon_chart_network_rounded),
                  label: 'Compose',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Amicons.iconly_profile_sharp_fill),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
