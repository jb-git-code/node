import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/clusters/views/clusters_screen.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/features/nodes/views/compose.dart';
import 'package:node/features/feed/views/explore.dart';
import 'package:node/features/feed/views/home.dart';
import 'package:node/user/about.dart';
import 'package:node/user/profile.dart';
import 'package:node/user/settings.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(LucideIcons.bell, size: 20),
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

  void openAbout() async {
    final url = Uri.parse('https://github.com/jb-git-code/node');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logoutPopUp(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(LucideIcons.logOut, size: 32),
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to access your account.',
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
      // ref.invalidate(currentUserProvider);
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (conetxt) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(currentUserProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        title: Text('Node'),
        centerTitle: false,
        toolbarHeight: 36,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            offset: const Offset(0, 44), // drops below the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                  break;
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                  break;
                case 'about':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                case 'logout':
                  logoutPopUp(context);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(LucideIcons.user),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(LucideIcons.settings),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(LucideIcons.info),
                  title: Text('About'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(LucideIcons.logOut),
                  title: Text('Log out'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
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
            ClustersScreen(),
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
                  icon: Icon(LucideIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.compass),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.plusSquare),
                  label: 'Compose',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.boxes),
                  label: 'Clusters',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
