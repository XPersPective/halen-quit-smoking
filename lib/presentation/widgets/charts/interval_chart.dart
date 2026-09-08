import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class IntervalChartCard extends StatelessWidget {
  const IntervalChartCard({super.key, required this.report});

  final DailyIntervalsReport report;

  String _formatMinutes(int minutes, AppLocalizations l10n) {
    if (minutes <= 0) return l10n.intervalMinutes(0);
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
                    color: HalenColors.skyBlue.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.timelapse_rounded,
                    color: HalenColors.skyBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.intervalTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        l10n.intervalSubtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Metrics row
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

            // Current smoke-free streak
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    HalenColors.skyBlue.withValues(alpha: 0.14),
                    HalenColors.skyBlue.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 20,
                    color: HalenColors.skyBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.intervalCurrent,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatMinutes(report.currentSmokeFreeMinutes, l10n),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: HalenColors.skyBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (report.items.length >= 2) ...[
              const SizedBox(height: 24),
              Text(l10n.chartIntervalAxis, style: theme.textTheme.labelMedium),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: math.max(
                      constraints.maxWidth,
                      (report.items.length - 1) * 56.0,
                    ),
                    height: 176,
                    child: Semantics(
                      image: true,
                      label: report.items
                          .where((item) => item.gapFromPrevious != null)
                          .map(
                            (item) => l10n.intervalMinutes(
                              item.gapFromPrevious!.inMinutes,
                            ),
                          )
                          .join(', '),
                      child: _IntervalBarsPainterWidget(
                        report: report,
                        theme: theme,
                      ),
                    ),
                  ),
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
                        : l10n.chartIntervalEmpty,
                    style: theme.textTheme.bodySmall,
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

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.55,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 13, color: color),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _IntervalBarsPainterWidget extends StatelessWidget {
  const _IntervalBarsPainterWidget({required this.report, required this.theme});

  final DailyIntervalsReport report;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _IntervalPainter(items: report.items, theme: theme),
    );
  }
}

class _IntervalPainter extends CustomPainter {
  _IntervalPainter({required this.items, required this.theme});

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
    final barWidth = math.min(30.0, step * 0.62);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var i = 0; i < count; i++) {
      final gap = gaps[i];
      final isLast = i == count - 1;
      final usableHeight = size.height - 42;
      final barHeight = math.max(6.0, (gap / maxGap) * usableHeight);
      final x = i * step + (step - barWidth) / 2;
      final y = (size.height - 22) - barHeight;

      final color = isLast
          ? theme.colorScheme.primary
          : theme.colorScheme.primary.withValues(alpha: 0.38);

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(8),
      );

      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withValues(alpha: isLast ? 0.75 : 0.2)],
        ).createShader(rRect.outerRect);

      canvas.drawRRect(rRect, barPaint);

      // Minutes on top of each bar
      textPainter.text = TextSpan(
        text: '$gap',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isLast
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, y - 16),
      );

      // Cigarette pair label below: "1–2", "2–3"
      textPainter.text = TextSpan(
        text: '${i + 1}–${i + 2}',
        style: TextStyle(
          fontFamily: 'Roboto',
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
