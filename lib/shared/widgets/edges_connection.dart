import 'package:flutter/material.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_text_styles.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/shared/models/user.dart';

class EdgeConnectionTile extends StatelessWidget {
  final UserModel usr;
  final VoidCallback onDisconnect;

  const EdgeConnectionTile({
    Key? key,
    required this.usr,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppUI.paddingMedium,
      ),
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryGreen,
        child: Text(
          usr.name[0],
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      title: Text(usr.name, style: AppTextStyles.bodyMain),
      subtitle: Text(usr.collegeId, style: AppTextStyles.caption),
      trailing: IconButton(
        icon: const Icon(Icons.share, color: AppColors.primaryPurple),
        onPressed: onDisconnect,
        tooltip: 'Remove Edge',
      ),
    );
  }
}
