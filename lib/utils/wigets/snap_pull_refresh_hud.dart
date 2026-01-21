import 'dart:math' as math;

import 'package:flutter/material.dart';

class SnapPullRefreshHud extends StatelessWidget {
  final dynamic appColors;
  final double progress;
  final bool isArmed;
  final bool isRefreshing;
  final bool showSuccess;
  final String subtitle;
  final Animation<double> spinTurns;

  const SnapPullRefreshHud({
    super.key,
    required this.appColors,
    required this.progress,
    required this.isArmed,
    required this.isRefreshing,
    required this.showSuccess,
    required this.subtitle,
    required this.spinTurns,
  });

  @override
  Widget build(BuildContext context) {
    final visible = isRefreshing || showSuccess || progress > 0.02;

    final label = isRefreshing
        ? 'Refreshing'
        : showSuccess
            ? 'Updated'
            : isArmed
                ? 'Release to refresh'
                : 'Pull to refresh';

    final caption = isRefreshing
        ? 'Syncing latest data'
        : showSuccess
            ? subtitle
            : '';

    final icon = showSuccess ? Icons.check_rounded : Icons.refresh_rounded;

    final arrowRotation = progress * math.pi;

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        offset: visible ? Offset.zero : const Offset(0, -0.4),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: appColors.card,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: appColors.border.withValues(alpha:0.6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 26,
                  height: 26,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2.4,
                        backgroundColor: appColors.border.withValues(alpha:0.25),
                        valueColor: AlwaysStoppedAnimation(appColors.secondary),
                        value: isRefreshing ? null : (showSuccess ? 1.0 : progress),
                      ),
                      if (showSuccess)
                        Icon(icon, size: 16, color: appColors.profit)
                      else if (isRefreshing)
                        RotationTransition(
                          turns: spinTurns,
                          child: Icon(icon, size: 16, color: appColors.secondary),
                        )
                      else
                        Transform.rotate(
                          angle: arrowRotation,
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 16,
                            color: isArmed ? appColors.secondary : appColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.textPrimary, fontWeight: FontWeight.w800),
                    ),
                    if (caption.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          caption,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: appColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
