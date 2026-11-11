import 'package:flutter/material.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_text_styles.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/features/edges/views/edgess.dart';
import 'package:node/features/nodes/views/node_profile.dart';
import 'package:node/shared/models/user.dart';

class EdgeConnectionTile extends StatelessWidget {
  final UserModel usr;
  final String cu;

  const EdgeConnectionTile({Key? key, required this.usr, required this.cu})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppUI.paddingMedium,
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NodeProfile(usr: usr)),
          );
        },
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            usr.name[0],
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ),
      title: Text(usr.name, style: AppTextStyles.bodyMain),
      subtitle: Text(usr.collegeId, style: AppTextStyles.caption),
      trailing: EdgeActionButton(currentUserId: cu, targetUserId: usr.authorId),
    );
  }
}
