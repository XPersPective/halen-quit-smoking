import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class IntervalChartCard extends StatelessWidget {
  const IntervalChartCard({
    super.key,
    required this.report,
  });

  final DailyIntervalsReport report;

  String _formatMinutes(int minutes, AppLocalizations l10n) {
    if (minutes <= 0) return '0 ${l10n.intervalMinutes(0)}';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) {
      return l10n.intervalHoursMinutes(h, m);
    }
    return l10n.intervalMinutes(m);
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
                    color: HalenColors.skyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.timelapse_rounded,
                    color: HalenColors.skyBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.intervalTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.intervalSubtitle,
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
            const SizedBox(height: 20),

            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: l10n.intervalAverage,
                    value: _formatMinutes(report.averageGapMinutes, l10n),
                    icon: Icons.av_timer_rounded,
                    color: HalenColors.emerald,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: l10n.intervalLongest,
                    value: _formatMinutes(report.longestGapMinutes, l10n),
                    icon: Icons.star_rounded,
                    color: HalenColors.amberCta,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Current streak tile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? HalenColors.surfaceElevatedDark
                    : HalenColors.surfaceElevatedLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 20,
                    color: HalenColors.skyBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.intervalCurrent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatMinutes(report.currentSmokeFreeMinutes, l10n),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: HalenColors.skyBlue,
                    ),
                  ),
                ],
              ),
            ),

            if (report.items.length >= 2) ...[
              const SizedBox(height: 24),
              Text(
                'Aralık Dağılım Grafiği (Dakika)',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: _IntervalBarsPainterWidget(
                  report: report,
                  theme: theme,
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    report.items.isEmpty
                        ? l10n.todayLogEmpty
                        : 'Aralık grafiği için bugün en az 2 sigara kaydı gereklidir.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? HalenColors.textSecondaryDark
                          : HalenColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? HalenColors.surfaceElevatedDark
            : HalenColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? HalenColors.textSecondaryDark
                        : HalenColors.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntervalBarsPainterWidget extends StatelessWidget {
  const _IntervalBarsPainterWidget({
    required this.report,
    required this.theme,
  });

  final DailyIntervalsReport report;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _IntervalPainter(
        items: report.items,
        theme: theme,
      ),
    );
  }
}

class _IntervalPainter extends CustomPainter {
  _IntervalPainter({
    required this.items,
    required this.theme,
  });

  final List<CigaretteIntervalItem> items;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    // Only intervals between items (index 1 to items.length - 1)
    final gaps = <int>[];
    for (var i = 1; i < items.length; i++) {
      gaps.add(items[i].gapFromPrevious?.inMinutes ?? 0);
    }
    if (gaps.isEmpty) return;

    final maxGap = math.max(60, gaps.reduce(math.max));
    final count = gaps.length;
    final step = size.width / count;
    final barWidth = math.min(32.0, step * 0.65);

    // Draw baseline
    final baseLinePaint = Paint()
      ..color = theme.colorScheme.outline
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      baseLinePaint,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var i = 0; i < count; i++) {
      final gap = gaps[i];
      final usableHeight = size.height - 40;
      final barHeight = math.max(6.0, (gap / maxGap) * usableHeight);
      final x = i * step + (step - barWidth) / 2;
      final y = (size.height - 20) - barHeight;

      // Color coding: Green if >= 120 mins, Amber if 60-120 mins, Coral if < 60 mins
      final Color color = gap >= 120
          ? HalenColors.emerald
          : gap >= 60
              ? HalenColors.amberCta
              : HalenColors.coral;

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );

      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withValues(alpha: 0.65)],
        ).createShader(rRect.outerRect);

      canvas.drawRRect(rRect, barPaint);

      // Label on top of bar (minutes or h:m)
      final labelText = gap >= 60 ? '${gap ~/ 60}s ${gap % 60}d' : '$gap dk';
      textPainter.text = TextSpan(
        text: labelText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, y - 16),
      );

      // Label below bar: "#1-2", "#2-3"
      final indexText = '#${i + 1}→${i + 2}';
      textPainter.text = TextSpan(
        text: indexText,
        style: TextStyle(
          fontSize: 9,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(_IntervalPainter old) => true;
}
