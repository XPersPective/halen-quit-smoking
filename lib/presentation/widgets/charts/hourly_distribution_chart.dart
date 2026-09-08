import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class HourlyDistributionCard extends StatelessWidget {
  const HourlyDistributionCard({
    super.key,
    required this.report,
  });

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
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HalenColors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: HalenColors.purple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.hourlyTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.hourlySubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? HalenColors.textSecondaryDark
                              : HalenColors.textSecondaryLight,
                        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: HalenColors.amberCta.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HalenColors.amberCta.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: HalenColors.amberCta,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.hourlyPeak(report.peakHour!, report.peakCount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.amber[200] : Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 24 Hour Histogram Canvas
            SizedBox(
              height: 140,
              child: CustomPaint(
                size: Size.infinite,
                painter: _Hourly24Painter(
                  buckets: report.buckets,
                  peakHour: report.peakHour,
                  theme: theme,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Günün Zaman Dilimleri',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Time blocks grid
            Column(
              children: [
                for (final b in report.blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? HalenColors.surfaceElevatedDark
                            : HalenColors.surfaceElevatedLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _blockIcon(b.nameKey),
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _blockTitle(b.nameKey, l10n),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: b.percentage,
                                minHeight: 6,
                                backgroundColor: theme.colorScheme.outline,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${b.count}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
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
    final barWidth = math.max(4.0, step - 3.5);
    final baselineY = size.height - 20;

    // Draw baseline
    final baseLinePaint = Paint()
      ..color = theme.colorScheme.outline
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      baseLinePaint,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var h = 0; h < 24; h++) {
      final count = buckets[h].count;
      final isPeak = h == peakHour && count > 0;
      final usableHeight = size.height - 35;
      final barHeight = count > 0
          ? math.max(6.0, (count / maxCount) * usableHeight)
          : 2.0;

      final x = h * step + (step - barWidth) / 2;
      final y = baselineY - barHeight;

      final Color barColor = isPeak
          ? HalenColors.amberCta
          : count > 0
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.5);

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(3),
      );

      final barPaint = Paint()..color = barColor;
      canvas.drawRRect(rRect, barPaint);

      // Label hours every 4 hours: 00, 04, 08, 12, 16, 20
      if (h % 4 == 0 || h == 23) {
        textPainter.text = TextSpan(
          text: h.toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: 9,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, baselineY + 4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_Hourly24Painter old) => true;
}
