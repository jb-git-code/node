import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/theme_provider.dart';
import 'package:node/screens/saved_nodes.dart';
import 'package:node/widgets/theme_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  ProfileScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: Text(
                'Profile Data + links',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
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
                  Icon(Amicons.remix_information, color: Colors.black),
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
        ],
      ),
    );
  }
}
