import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class HourlyDistributionCard extends StatelessWidget {
  const HourlyDistributionCard({super.key, required this.report});

  final HourlyAnalyticsReport report;

  IconData _blockIcon(String key) {
    return switch (key) {
      'timeMorning' => Icons.wb_sunny_outlined,
      'timeAfternoon' => Icons.wb_cloudy_outlined,
      'timeEvening' => Icons.nights_stay_outlined,
      'timeNight' => Icons.bedtime_outlined,
      _ => Icons.schedule_rounded,
    };
  }

  String _blockTitle(String key, AppLocalizations l10n) {
    return switch (key) {
      'timeMorning' => l10n.timeMorning,
      'timeAfternoon' => l10n.timeAfternoon,
      'timeEvening' => l10n.timeEvening,
      'timeNight' => l10n.timeNight,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: HalenColors.purple.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: HalenColors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.hourlyTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        l10n.hourlySubtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Peak hour badge
            if (report.peakHour != null && report.peakCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: HalenColors.amberCta.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: HalenColors.amberCta,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.hourlyPeak(report.peakHour!, report.peakCount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: HalenColors.amberCta,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 24 hour histogram
            Semantics(
              label: report.buckets
                  .map((b) => "${b.hour}:00: ${b.count}")
                  .join(", "),
              image: true,
              child: SizedBox(
                height: 176,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _Hourly24Painter(
                    buckets: report.buckets,
                    peakHour: report.peakHour,
                    theme: theme,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.chartTimeBlocks,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 10),

            // Time blocks
            Column(
              children: [
                for (final b in report.blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _blockIcon(b.nameKey),
                              size: 15,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _blockTitle(b.nameKey, l10n),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 72,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: LinearProgressIndicator(
                                value: b.percentage,
                                minHeight: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 24,
                            child: Text(
                              '${b.count}',
                              textAlign: TextAlign.end,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Hourly24Painter extends CustomPainter {
  _Hourly24Painter({
    required this.buckets,
    required this.peakHour,
    required this.theme,
  });

  final List<HourBucket> buckets;
  final int? peakHour;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    if (buckets.length != 24) return;

    final maxCount = buckets.fold(1, (a, b) => a > b.count ? a : b.count);
    final step = size.width / 24;
    final barWidth = math.max(4.0, step - 4.5);
    final baselineY = size.height - 22;
    final usableHeight = size.height - 40;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var h = 0; h < 24; h++) {
      final count = buckets[h].count;
      final isPeak = h == peakHour && count > 0;
      final barHeight = count > 0
          ? math.max(6.0, (count / maxCount) * usableHeight)
          : 2.5;

      final x = h * step + (step - barWidth) / 2;
      final y = baselineY - barHeight;

      final baseColor = isPeak
          ? HalenColors.amberCta
          : count > 0
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.5);

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(math.min(barWidth / 2, 4)),
      );

      final barPaint = count > 0
          ? (Paint()
              ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  baseColor,
                  baseColor.withValues(alpha: isPeak ? 0.85 : 0.55),
                ],
              ).createShader(rRect.outerRect))
          : (Paint()..color = baseColor);
      canvas.drawRRect(rRect, barPaint);

      // Hour labels every 6 hours: 00, 06, 12, 18
      if (h % 6 == 0) {
        textPainter.text = TextSpan(
          text: h.toString().padLeft(2, '0'),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            (h + 0.5) * step - textPainter.width / 2,
            baselineY + 6,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_Hourly24Painter old) => true;
}
