import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/theme_provider.dart';
import 'package:node/widgets/theme_slider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<String> tabs = ['Settings', 'Connect', 'About'];

  @override
  Widget build(BuildContext context) {
    final currentMode = ref.watch(themeModeProvider);
    return Padding(
      padding: EdgeInsetsGeometry.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lime,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 250,
            width: MediaQuery.of(context).size.width * .90,
            child: Center(
              child: Text(
                'Profile Data + links',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // SegmentedButton<ThemeMode>(
          //   segments: const [
          //     ButtonSegment(
          //       value: ThemeMode.system,
          //       icon: Icon(Icons.brightness_auto),
          //       label: Text('System'),
          //     ),
          //     ButtonSegment(
          //       value: ThemeMode.light,
          //       icon: Icon(Icons.light_mode),
          //       label: Text('Light'),
          //     ),
          //     ButtonSegment(
          //       value: ThemeMode.dark,
          //       icon: Icon(Icons.dark_mode),
          //       label: Text('Dark'),
          //     ),
          //   ],
          //   selected: {currentMode},
          //   onSelectionChanged: (Set<ThemeMode> newSelection) {
          //     ref.read(themeModeProvider.notifier).state = newSelection.first;
          //   },
          // ),
          ThemeSlider(),
          const SizedBox(height: 20),
          Card(
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * .90,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(Amicons.remix_information),
                  const SizedBox(width: 10),
                  Text('About'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
