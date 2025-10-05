class DashboardFormatters {
  /// Format study time in minutes to human-readable string
  static String formatStudyTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}m';
  }

  /// Format percentage with one decimal place
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }

  /// Format quiz score as percentage
  static String formatQuizScore(double score) {
    return '${score.round()}%';
  }

  /// Format time ago from timestamp
  static String formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  /// Format streak count
  static String formatStreak(int days) {
    if (days == 0) return 'Start today!';
    if (days == 1) return '1 day';
    return '$days days';
  }

  /// Format module count
  static String formatModuleCount(int completed, int total) {
    return '$completed/$total';
  }

  /// Format completion ratio as fraction
  static String formatCompletionRatio(int completed, int total) {
    if (total == 0) return '0/0';
    return '$completed/$total';
  }

  /// Get progress status text
  static String getProgressStatus(double percentage) {
    if (percentage >= 90) return 'Almost done!';
    if (percentage >= 75) return 'Great progress!';
    if (percentage >= 50) return 'Halfway there!';
    if (percentage >= 25) return 'Good start!';
    return 'Just beginning!';
  }

  /// Format large numbers with K/M suffix
  static String formatLargeNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      final k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    final m = number / 1000000;
    return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
  }
}
