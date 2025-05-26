import 'package:flutter/material.dart';

import '../../../../shared/providers/user_provider.dart';

class ProfileAvatar extends StatelessWidget {
  final UserProfile profile;
  final double size;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const ProfileAvatar({
    super.key,
    required this.profile,
    this.size = 50,
    this.onTap,
    this.showEditIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage: profile.avatarUrl != null
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: profile.avatarUrl == null
                ? Text(
                    profile.initials,
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : null,
          ),
          if (showEditIcon && onTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.edit,
                  size: size * 0.2,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
