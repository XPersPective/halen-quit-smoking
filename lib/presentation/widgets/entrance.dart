import 'package:flutter/material.dart';

/// A short rise-and-fade used when module cards first appear.
///
/// Deliberately restrained: 8 logical pixels and under a third of a second,
/// staggered by position so a screen assembles instead of popping. Anything
/// larger reads as decoration on a screen people open several times a day —
/// and reduce-motion skips it entirely, since it carries no information.
class Entrance extends StatefulWidget {
  const Entrance({
    super.key,
    required this.child,
    this.index = 0,
    this.stagger = const Duration(milliseconds: 60),
  });

  final Widget child;

  /// Position in the list, used to offset the start.
  final int index;

  final Duration stagger;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else if (_controller.isDismissed) {
      Future<void>.delayed(widget.stagger * widget.index, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) => Opacity(
        opacity: curved.value,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - curved.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
