import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/themes/app_color.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';

class StatsGrid extends ConsumerWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final averageQuizTime = ref
        .watch(questionStatusProvider.notifier)
        .getAverageAnswerTime();

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _StatCard(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedBookOpen02,
            color: cs.secondary,
            size: 16,
          ),
          title: 'Chapter Test',
          value: '10/20', //* TODO: riverpod value
          subtitle: 'Completed',
          color: cs.secondary,
        ),
        const _StatCard(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedQuiz03,
            color: AppColors.warningColor,
            size: 16,
          ),
          title: 'Quizzes',
          value: '32/239', //* TODO: riverpod value
          subtitle: 'Completed',
          color: AppColors.warningColor,
        ),
        const _StatCard(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: AppColors.successColor,
            size: 16,
          ),
          title: 'Study Time',
          value: '1h, 34m', //* TODO: riverpod value
          subtitle: 'Total',
          color: AppColors.successColor,
        ),
        _StatCard(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedTimer02,
            color: Colors.purple,
            size: 16,
          ),
          title: 'Quiz Time',
          value: '${averageQuizTime.toStringAsFixed(1)} s',
          subtitle: 'Per Questions',
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(52), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(2, 4),
          ),
          BoxShadow(
            color: color.withAlpha(26),
            blurRadius: 15,
            offset: const Offset(-5, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: icon,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: cs.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: cs.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: cs.onSurface.withAlpha(180),
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
