import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// One clock for the whole app's living animation (premium brief §B.8).
///
/// Every breathing thing used to own an `AnimationController`: the lung, the
/// body map, each organ glyph, the SOS ring. On one screen that meant five
/// independent tickers — more work than needed, and worse, they drifted out
/// of phase, so a screen with two breathing elements looked like two separate
/// animations rather than one body.
///
/// **The clock is lazy on purpose.** A ticker that runs unconditionally
/// schedules a frame forever, and in Flutter's test binding that means
/// `pumpAndSettle` never returns — one app-wide always-on clock would have
/// deadlocked every widget test in the suite. So the ticker runs only while
/// at least one [BodyPulse] is mounted, and a screen with nothing pulsing on
/// it costs nothing and settles normally.
///
/// Under reduce-motion the clock holds at a fixed, well-composed frame rather
/// than resetting to zero: a paused animation should look deliberate.
class BodyClock extends StatefulWidget {
  const BodyClock({super.key, required this.child});

  final Widget child;

  @override
  State<BodyClock> createState() => _BodyClockState();

  static _ClockNotifier? _maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_ClockScope>()
          ?.notifier;

  /// Seconds since the clock started; 1.0 when held or absent.
  static double secondsOf(BuildContext context) =>
      _maybeOf(context)?.seconds ?? 1;

  /// Phase 0..1 through a cycle of [period], for this build.
  static double phase(BuildContext context, Duration period) =>
      phaseOf(secondsOf(context), period);

  /// Pure form, for painters that already hold the time value.
  static double phaseOf(double seconds, Duration period) {
    final cycle = period.inMilliseconds / 1000;
    return cycle <= 0 ? 0 : (seconds % cycle) / cycle;
  }
}

class _BodyClockState extends State<BodyClock>
    with SingleTickerProviderStateMixin {
  late final _ClockNotifier _notifier = _ClockNotifier(this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier.reduceMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _ClockScope(notifier: _notifier, child: widget.child);
}

class _ClockNotifier extends ChangeNotifier {
  _ClockNotifier(TickerProvider vsync) {
    _ticker = vsync.createTicker(_onTick);
  }

  late final Ticker _ticker;
  int _subscribers = 0;
  bool _reduceMotion = false;

  /// Held a quarter into the cycle: mid-inhale, mid-beat. A frozen frame at
  /// zero reads as broken; this one reads as held.
  double seconds = 1;

  set reduceMotion(bool value) {
    if (_reduceMotion == value) {
      return;
    }
    _reduceMotion = value;
    _sync();
  }

  void acquire() {
    _subscribers++;
    _sync();
  }

  void release() {
    _subscribers--;
    _sync();
  }

  void _sync() {
    final shouldRun = _subscribers > 0 && !_reduceMotion;
    if (shouldRun && !_ticker.isActive) {
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
      seconds = 1;
      notifyListeners();
    }
  }

  void _onTick(Duration elapsed) {
    seconds = elapsed.inMilliseconds / 1000;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class _ClockScope extends InheritedNotifier<_ClockNotifier> {
  const _ClockScope({required _ClockNotifier notifier, required super.child})
      : super(notifier: notifier);
}

/// Something that lives: rebuilds on every frame of the shared clock, and
/// keeps that clock running only for as long as it is on screen.
///
/// [builder] receives the elapsed seconds; derive a phase from it with
/// [BodyClock.phaseOf] so that everything on screen stays locked to the same
/// cycle. With no [BodyClock] above it (a bare widget test) the builder still
/// runs, once, at the held frame.
class BodyPulse extends StatefulWidget {
  const BodyPulse({super.key, required this.builder});

  final Widget Function(BuildContext context, double seconds) builder;

  @override
  State<BodyPulse> createState() => _BodyPulseState();
}

class _BodyPulseState extends State<BodyPulse> {
  _ClockNotifier? _notifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = BodyClock._maybeOf(context);
    if (identical(next, _notifier)) {
      return;
    }
    _notifier?.release();
    _notifier = next?..acquire();
  }

  @override
  void dispose() {
    _notifier?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, BodyClock.secondsOf(context));
}
