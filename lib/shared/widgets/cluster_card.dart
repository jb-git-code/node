import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_text_styles.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/features/clusters/repository/cluster_repo.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/shared/models/user.dart';

class ClusterCard extends ConsumerStatefulWidget {
  final String clusterId;
  final String clusterName;
  final String description;
  final String tag;
  final int memberCount;
  final UserModel usr;

  const ClusterCard({
    Key? key,
    required this.clusterId,
    required this.clusterName,
    required this.description,
    required this.tag,
    required this.memberCount,
    required this.usr,
  }) : super(key: key);

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
    
    final hasJoined = widget.usr.joinedClusters.contains(widget.clusterId);
    return Container(
      margin: const EdgeInsets.only(bottom: AppUI.paddingMedium),
      padding: const EdgeInsets.all(AppUI.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppUI.cardRadius,
        boxShadow: AppUI.defaultShadow,
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
                  style: AppTextStyles.heading2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLavender,
                  borderRadius: AppUI.chipRadius,
                ),
                child: Text(
                  widget.tag,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppUI.paddingSmall),
          Text(
            widget.description,
            style: AppTextStyles.bodyMain.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppUI.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.memberCount} Members',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              SizedBox(
                height: 36,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: hasJoined
                        ? AppColors.backgroundLavender
                        : AppColors.primaryGreen,
                    foregroundColor: hasJoined
                        ? AppColors.primaryPurple
                        : AppColors.textPrimary,
                    elevation: 0,
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
