import 'package:flutter/material.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_text_styles.dart';
import 'package:node/core/themes/app_ui_config.dart';
class ClusterCard extends StatelessWidget {
  final String clusterName;
  final String description;
  final String tag;
  final int memberCount;
  final bool isJoined;
  final VoidCallback onJoinToggle;

  const ClusterCard({
    Key? key,
    required this.clusterName,
    required this.description,
    required this.tag,
    required this.memberCount,
    required this.isJoined,
    required this.onJoinToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  clusterName,
                  style: AppTextStyles.heading2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLavender,
                  borderRadius: AppUI.chipRadius,
                ),
                child: Text(
                  tag,
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
            description,
            style: AppTextStyles.bodyMain.copyWith(color: AppColors.textSecondary),
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
                    '$memberCount Members',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              SizedBox(
                height: 36,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isJoined 
                        ? AppColors.backgroundLavender 
                        : AppColors.primaryGreen,
                    foregroundColor: isJoined 
                        ? AppColors.primaryPurple 
                        : AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppUI.chipRadius,
                    ),
                  ),
                  onPressed: onJoinToggle,
                  child: Text(
                    isJoined ? 'Joined' : 'Join',
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