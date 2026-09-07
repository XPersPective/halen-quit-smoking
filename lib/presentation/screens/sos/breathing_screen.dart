import 'dart:async';

import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// 60-second guided box breathing (report §15).
///
/// 4 s in → 4 s hold → 4 s out → 4 s hold, 3.75 cycles in a minute. The
/// circle scales with the phase. Motion respects the OS reduce-motion flag:
/// with animations disabled the guide runs as text + countdown only.
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
      value: 0.25, // Start mid-"in" phase so the circle is never at rest.
    );
    _scale = Tween(begin: 0.55, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

  String _phaseLabel(AppLocalizations l10n) {
    final phaseIndex = (_elapsed ~/ _phaseSeconds) % 4;
    return switch (phaseIndex) {
      0 => l10n.sosBreathingIn,
      1 => l10n.sosBreathingHold,
      2 => l10n.sosBreathingOut,
      _ => l10n.sosBreathingHold,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final reduceMotion =
        MediaQuery.of(context).disableAnimations || _finished;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sos4dBreathe)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_finished)
                Text(l10n.sosBreathingFinished,
                    style: theme.textTheme.headlineSmall)
              else ...[
                Text(
                  '${_totalSeconds - _elapsed} s',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                    ),
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scaleByDouble(
                        reduceMotion ? 0.9 : _scale.value,
                        reduceMotion ? 0.9 : _scale.value,
                        1,
                        1,
                      ),
                    child: Center(
                      child: Text(
                        _phaseLabel(l10n),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonDone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
