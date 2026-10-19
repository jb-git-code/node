import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/theme_provider.dart';
import 'package:node/screens/compose.dart';
import 'package:node/screens/explore.dart';
import 'package:node/screens/home.dart';
import 'package:node/screens/profile.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  int _currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeValue = ref.watch(darkThemeProvider);
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        title: Text('Node'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(darkThemeProvider.notifier).state = !themeValue;
            },
            icon: (themeValue) ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
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
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_alt),
                  label: 'Compose',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_outlined),
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
