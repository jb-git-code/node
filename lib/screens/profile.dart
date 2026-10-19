import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<String> tabs = ['Settings', 'Themes', 'Connect', 'About'];

  @override
  Widget build(BuildContext context) {
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
          Divider(),
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  print('touched');
                },
                child: Card(child: ListTile(title: Text(tabs[index]))),
              ),
            );
          }),
        ],
      ),
    );
  }
}
