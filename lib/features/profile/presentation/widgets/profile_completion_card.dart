import 'package:flutter/material.dart';

import '../../../../shared/providers/user_provider.dart';

class ProfileCompletionCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileCompletionCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final completionPercentage = profile.profileCompletionPercentage;
    final isComplete = profile.isProfileComplete;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete ? Icons.check_circle : Icons.account_circle,
                  color: isComplete
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Profile Completion',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${(completionPercentage * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completionPercentage,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),
            if (isComplete)
              Row(
                children: [
                  Icon(
                    Icons.celebration,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Your profile is complete!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete your profile to get the most out of the app:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  ..._buildCompletionSuggestions(context),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompletionSuggestions(BuildContext context) {
    final suggestions = <Widget>[];

    if (profile.user.name?.isEmpty ?? true) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Add your name',
        Icons.person,
      ));
    }

    if (!profile.user.isEmailVerified) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Verify your email',
        Icons.email,
      ));
    }

    if (profile.bio?.isEmpty ?? true) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Add a bio',
        Icons.description,
      ));
    }

    if (profile.avatarUrl == null) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Upload a profile photo',
        Icons.photo_camera,
      ));
    }

    if (profile.phoneNumber == null) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Add your phone number',
        Icons.phone,
      ));
    }

    if (profile.dateOfBirth == null) {
      suggestions.add(_buildSuggestionItem(
        context,
        'Add your date of birth',
        Icons.cake,
      ));
    }

    return suggestions;
  }

  Widget _buildSuggestionItem(
      BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
