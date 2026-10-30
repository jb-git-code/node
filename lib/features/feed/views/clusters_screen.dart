import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/cluster_provider.dart';
import 'package:node/shared/widgets/cluster_card.dart';

class ClustersScreen extends ConsumerStatefulWidget {
  const ClustersScreen({super.key});

  @override
  ConsumerState<ClustersScreen> createState() => _ClustersScreenState();
}

class _ClustersScreenState extends ConsumerState<ClustersScreen> {
  @override
  Widget build(BuildContext context) {
    final clusterAsync = ref.watch(clusterProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Cluster List')),
      body: clusterAsync.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final clusterItem = data[index];
              return ClusterCard(
                clusterName: clusterItem.clusterName,
                description: clusterItem.description,
                tag: clusterItem.tag,
                memberCount: clusterItem.memberCount,
                isJoined: false,
                onJoinToggle: () {},
              );
            },
          );
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
