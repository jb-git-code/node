import 'package:flutter/material.dart';
import 'package:node/core/themes/app_ui_config.dart';

class ClusterCard extends StatefulWidget {
  const ClusterCard({super.key});

  @override
  State<ClusterCard> createState() => _ClusterCardState();
}

class _ClusterCardState extends State<ClusterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppUI.cardRadius,
      ),
      height: 200,
      child: Center(
        child: Text('Cluster Card'),
      ),
    );
  }
}