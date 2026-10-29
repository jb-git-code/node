import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_ui_config.dart';

class NetworkGraphScreen extends StatefulWidget {
  const NetworkGraphScreen({Key? key}) : super(key: key);

  @override
  State<NetworkGraphScreen> createState() => _NetworkGraphScreenState();
}

class _NetworkGraphScreenState extends State<NetworkGraphScreen> {
  final Graph graph = Graph()..isTree = false;
  late FruchtermanReingoldAlgorithm algorithm;

  @override
  void initState() {
    super.initState();
    algorithm = FruchtermanReingoldAlgorithm(
      FruchtermanReingoldConfiguration(),
    );
    _buildGraph();
  }

  void _buildGraph() {
    // 1. Create the central node (The User)
    final meNode = Node.Id('Me');

    // 2. Create Cluster Nodes
    final flutterCluster = Node.Id('# Flutter Hub');
    final cpCluster = Node.Id('# Competitive Programming');

    // 3. Create Edge Nodes (Connected Students)
    final studentA = Node.Id('Aman (BITS)');
    final studentB = Node.Id('Priya (DTU)');

    // 4. Connect everything to the central user node
    graph.addEdge(meNode, flutterCluster);
    graph.addEdge(meNode, cpCluster);
    graph.addEdge(meNode, studentA);
    graph.addEdge(meNode, studentB);

    // Optional: Connect students to clusters they also share
    graph.addEdge(studentA, flutterCluster);
  }

  Widget _buildNodeWidget(Node node) {
    final label = node.key!.value.toString();
    final isMe = label == 'Me';
    final isCluster = label.startsWith('#');

    return InkWell(
      onTap: () {
        // TODO: Navigate to cluster or user profile
      },
      child: Container(
        padding: const EdgeInsets.all(AppUI.paddingMedium),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primaryGreen
              : (isCluster ? AppColors.surfaceDark : AppColors.surfaceWhite),
          shape: isCluster ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: isCluster ? AppUI.cardRadius : null,
          boxShadow: AppUI.defaultShadow,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isCluster ? AppColors.surfaceWhite : AppColors.textPrimary,
            fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLavender,
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1,
        maxScale: 2.0,
        child: GraphView(
          graph: graph,
          algorithm: algorithm,
          paint: Paint()
            ..color = AppColors.primaryGreen.withOpacity(0.5)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
          builder: (Node node) => _buildNodeWidget(node),
        ),
      ),
    );
  }
}
