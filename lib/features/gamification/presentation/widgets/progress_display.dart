import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_progress_provider.dart';

class ProgressDisplay extends ConsumerWidget {
  const ProgressDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${progress.level}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${progress.points} points',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              _buildLevelIcon(progress.level, theme),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: ref.read(userProgressProvider.notifier).getLevelProgress(),
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${ref.read(userProgressProvider.notifier).getNextLevelPoints()} points to next level',
            style: theme.textTheme.bodySmall,
          ),
          if (progress.unlockedAchievements.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Achievements',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: progress.unlockedAchievements.map((achievement) {
                return _buildAchievementBadge(achievement, theme);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLevelIcon(int level, ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String achievement, ThemeData theme) {
    IconData icon;
    String title;
    Color color;

    switch (achievement) {
      case 'focus_master':
        icon = Icons.emoji_events;
        title = 'Focus Master';
        color = Colors.amber;
        break;
      case 'level_5':
        icon = Icons.star;
        title = 'Level 5';
        color = Colors.blue;
        break;
      case 'consistent':
        icon = Icons.trending_up;
        title = 'Consistent';
        color = Colors.green;
        break;
      default:
        icon = Icons.emoji_events;
        title = 'Achievement';
        color = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
