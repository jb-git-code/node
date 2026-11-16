// features/clusters/views/joined_clusters_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/clusters/providers/cluster_provider.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/shared/widgets/cluster_card.dart';

class JoinedClustersScreen extends ConsumerWidget {
  const JoinedClustersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clustersAsync = ref.watch(joinedClustersProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Joined Clusters')),
      body: clustersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't load your clusters."),
              TextButton(
                onPressed: () => ref.invalidate(joinedClustersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (clusters) {
          final user = userAsync.value;
          if (clusters.isEmpty || user == null) {
            return const Center(
              child: Text("You haven't joined any clusters yet."),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(joinedClustersProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: clusters.length,
              itemBuilder: (context, i) {
                final c = clusters[i];
                return ClusterCard(
                  clusterId: c.clusterId,
                  clusterName: c.clusterName,
                  description: c.description,
                  tag: c.tag,
                  memberCount: c.memberCount,
                  usr: user,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
