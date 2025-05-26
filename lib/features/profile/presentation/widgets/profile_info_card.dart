import 'package:flutter/material.dart';

import '../../../../shared/providers/user_provider.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEdit;

  const ProfileInfoCard({
    super.key,
    required this.profile,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Profile Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    tooltip: 'Edit Profile',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Name',
              profile.user.name ?? 'Not provided',
              Icons.person,
              isEmpty: profile.user.name?.isEmpty ?? true,
            ),
            const Divider(),
            _buildInfoRow(
              context,
              'Email',
              profile.user.email,
              Icons.email,
              trailing: profile.user.isEmailVerified
                  ? Icon(
                      Icons.verified,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.warning,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
            ),
            if (profile.phoneNumber != null) ...[
              const Divider(),
              _buildInfoRow(
                context,
                'Phone',
                profile.phoneNumber!,
                Icons.phone,
              ),
            ],
            if (profile.dateOfBirth != null) ...[
              const Divider(),
              _buildInfoRow(
                context,
                'Date of Birth',
                _formatDate(profile.dateOfBirth!),
                Icons.cake,
              ),
            ],
            if (profile.location != null && profile.location!.isNotEmpty) ...[
              const Divider(),
              _buildInfoRow(
                context,
                'Location',
                profile.location!,
                Icons.location_on,
              ),
            ],
            if (profile.website != null && profile.website!.isNotEmpty) ...[
              const Divider(),
              _buildInfoRow(
                context,
                'Website',
                profile.website!,
                Icons.language,
              ),
            ],
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const Divider(),
              _buildInfoSection(
                context,
                'Bio',
                profile.bio!,
                Icons.description,
              ),
            ],
            const Divider(),
            _buildInfoRow(
              context,
              'Member Since',
              _formatMemberSince(profile.user.createdAt),
              Icons.calendar_today,
            ),
            _buildInfoRow(
              context,
              'Last Updated',
              _formatLastUpdated(profile.lastUpdated),
              Icons.update,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Widget? trailing,
    bool isEmpty = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isEmpty
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : null,
                        fontStyle: isEmpty ? FontStyle.italic : null,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatMemberSince(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatLastUpdated(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return _formatDate(date);
    }
  }
}
