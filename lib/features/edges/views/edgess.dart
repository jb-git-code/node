import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/features/edges/repositories/edge_repo.dart';

class EdgeActionButton extends StatelessWidget {
  final String currentUserId;
  final String targetUserId;

  const EdgeActionButton({
    super.key,
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    final edgeRepo = EdgeRepository();
    // Generate the same consistent ID to listen to
    List<String> ids = [currentUserId, targetUserId];
    ids.sort();
    final edgeId = '${ids[0]}_${ids[1]}';

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('edges')
          .doc(edgeId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final doc = snapshot.data!;

        // no connection exists
        if (!doc.exists) {
          return FilledButton.icon(
            onPressed: () => edgeRepo.sendEdgeRequest(
              currentUserId: currentUserId,
              targetUserId: targetUserId,
            ),
            icon: Icon(
              LucideIcons.link2,
              color: Theme.of(context).colorScheme.surface,
            ),
            label: Text(
              'Connect Node',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          );
        }

        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'];
        final senderId = data['senderId'];

        // already edged
        if (status == 'connected') {
          return OutlinedButton.icon(
            onPressed: () => edgeRepo.deleteEdge(currentUserId, targetUserId),
            icon: const Icon(LucideIcons.link, color: AppColors.primaryPurple),
            label: const Text('Edge Established'),
          );
        }

        // pending edge request
        if (status == 'pending') {
          if (senderId == currentUserId) {
            // you sent the request
            return OutlinedButton(
              onPressed: () => edgeRepo.deleteEdge(currentUserId, targetUserId),
              child: Text(
                'Request Sent (Cancel)',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
            );
          } else {
            // they sent the request to you
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () => edgeRepo.acceptEdgeRequest(edgeId),
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: AppUI.paddingSmall),
                IconButton(
                  onPressed: () =>
                      edgeRepo.deleteEdge(currentUserId, targetUserId),
                  icon: Icon(
                    LucideIcons.x,
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                ),
              ],
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
