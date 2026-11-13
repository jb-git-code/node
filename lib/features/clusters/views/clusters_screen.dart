import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/clusters/providers/cluster_provider.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
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
    final currUser = ref.watch(currentUserProvider);
    final currentUser = currUser.value;
    return Scaffold(
      body: clusterAsync.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final clusterItem = data[index];

              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ClusterCard(
                  clusterId: clusterItem.clusterId,
                  clusterName: clusterItem.clusterName,
                  description: clusterItem.description,
                  tag: clusterItem.tag,
                  memberCount: clusterItem.memberCount,
                  usr: currentUser!,
                ),
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
