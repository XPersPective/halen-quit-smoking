import 'dart:async';

import 'package:flutter/material.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// 60-second guided box breathing (report §15).
///
/// 4 s in → 4 s hold → 4 s out → 4 s hold, 3.75 cycles in a minute.
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  static const _totalSeconds = 60;
  static const _phaseSeconds = 4;

  late final AnimationController _controller;
  late final Animation<double> _scale;
  int _elapsed = 0;
  Timer? _ticker;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _phaseSeconds),
      value: 0.25,
    );
    _scale = Tween(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.repeat(reverse: true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_elapsed + 1 >= _totalSeconds) {
      _ticker?.cancel();
      _controller.stop();
      setState(() {
        _elapsed = _totalSeconds;
        _finished = true;
      });
      return;
    }
    setState(() => _elapsed += 1);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int get _currentPhaseIndex => (_elapsed ~/ _phaseSeconds) % 4;

  String _phaseLabel(AppLocalizations l10n) {
    return switch (_currentPhaseIndex) {
      0 => l10n.sosBreathingIn,
      1 => l10n.sosBreathingHold,
      2 => l10n.sosBreathingOut,
      _ => l10n.sosBreathingHold,
    };
  }

  Color _phaseColor(ThemeData theme) {
    return switch (_currentPhaseIndex) {
      0 => HalenColors.emerald,
      1 => HalenColors.skyBlue,
      2 => theme.colorScheme.primary,
      _ => HalenColors.amberCta,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations || _finished;
    final phaseColor = _phaseColor(theme);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sos4dBreathe), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HalenSpace.x6),
          child: Column(
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _elapsed / _totalSeconds,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
                ),
              ),
              const SizedBox(height: HalenSpace.x3),
              Text(
                '${_totalSeconds - _elapsed} s',
                style: theme.textTheme.titleLarge,
              ),

              const Spacer(),

              if (_finished) ...[
                Container(
                  padding: const EdgeInsets.all(HalenSpace.x6),
                  decoration: BoxDecoration(
                    color: HalenColors.emerald.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 64,
                    color: HalenColors.emerald,
                  ),
                ),
                const SizedBox(height: HalenSpace.x6),
                Text(
                  l10n.sosBreathingFinished,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: HalenSpace.x2),
                Text(
                  l10n.todayFocusNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? HalenColors.textSecondaryDark
                        : HalenColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final scaleValue = reduceMotion ? 0.85 : _scale.value;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer subtle ripple
                        Container(
                          width: 260 * scaleValue,
                          height: 260 * scaleValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: phaseColor.withValues(alpha: 0.08),
                          ),
                        ),
                        // Middle ripple
                        Container(
                          width: 210 * scaleValue,
                          height: 210 * scaleValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: phaseColor.withValues(alpha: 0.15),
                          ),
                        ),
                        // Main core circle
                        Container(
                          width: 160 * scaleValue,
                          height: 160 * scaleValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                phaseColor,
                                phaseColor.withValues(alpha: 0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: phaseColor.withValues(alpha: 0.35),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(HalenSpace.x3),
                              child: Text(
                                _phaseLabel(l10n),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],

              const Spacer(),

              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(l10n.commonDone),
              ),
              const SizedBox(height: HalenSpace.x3),
            ],
          ),
        ),
      ),
    );
  }
}
