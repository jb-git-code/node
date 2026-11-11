import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/features/clusters/repository/cluster_repo.dart';
import 'package:node/shared/models/user.dart';

// Removed: app_colors.dart and app_text_styles.dart.
// All colors and text styles now come from Theme.of(context).

class ClusterCard extends ConsumerStatefulWidget {
  final String clusterId;
  final String clusterName;
  final String description;
  final String tag;
  final int memberCount;
  final UserModel usr;

  const ClusterCard({
    super.key,
    required this.clusterId,
    required this.clusterName,
    required this.description,
    required this.tag,
    required this.memberCount,
    required this.usr,
  });

  @override
  ConsumerState<ClusterCard> createState() => _ClusterCardState();
}

class _ClusterCardState extends ConsumerState<ClusterCard> {
  Future<void> _toggleJoin(String cid, String uid, bool isJoined) async {
    final repo = ClusterRepo();
    if (isJoined) {
      await repo.exitCluster(uid, cid);
    } else {
      await repo.joinCluster(uid, cid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hasJoined = widget.usr.joinedClusters.contains(widget.clusterId);

    return Container(
      margin: const EdgeInsets.only(bottom: AppUI.paddingMedium),
      padding: const EdgeInsets.all(AppUI.paddingLarge),
      decoration: BoxDecoration(
        color: colors.surface, // white (light) / dark grey (dark)
        borderRadius: AppUI.cardRadius,
        border: Border.all(
          color: colors.outline,
        ), // flat border instead of shadow
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.clusterName,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Tag chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh, // light grey
                  borderRadius: AppUI.chipRadius,
                ),
                child: Text(
                  widget.tag,
                  style: text.bodySmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppUI.paddingSmall),
          Text(
            widget.description,
            style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppUI.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.users,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.memberCount} Members',
                    style: text.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 36,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(64, 36),
                    // Not joined: solid black/white button
                    // Joined: quiet grey button with a border
                    backgroundColor: hasJoined
                        ? colors.surfaceContainerHigh
                        : colors.primary,
                    foregroundColor: hasJoined
                        ? colors.onSurface
                        : colors.onPrimary,
                    elevation: 0,
                    side: hasJoined ? BorderSide(color: colors.outline) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppUI.chipRadius,
                    ),
                  ),
                  onPressed: () {
                    _toggleJoin(
                      widget.clusterId,
                      widget.usr.authorId,
                      hasJoined,
                    );
                  },
                  child: Text(
                    hasJoined ? 'Joined' : 'Join',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
