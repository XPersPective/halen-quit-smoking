import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/cessation_providers.dart';
import '../../application/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'milestone_celebration.dart';

/// Fires the celebration exactly once per milestone (premium brief §A.8).
///
/// The rule that makes it a moment rather than an annoyance: **acknowledge
/// before showing.** The crossed milestone is written to the database first,
/// so a relaunch, a rebuild or a second tab cannot replay it — a celebration
/// that reappears every morning stops being one within two days.
///
/// It renders nothing. It sits in the Today tree, watches the day count, and
/// gets out of the way.
class MilestoneWatcher extends ConsumerStatefulWidget {
  const MilestoneWatcher({super.key});

  @override
  ConsumerState<MilestoneWatcher> createState() => _MilestoneWatcherState();
}

class _MilestoneWatcherState extends ConsumerState<MilestoneWatcher> {
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    if (_checking || !mounted) {
      return;
    }
    _checking = true;
    try {
      final quitDate = ref.read(cessationStateProvider).value?.quitDate;
      if (quitDate == null) {
        return;
      }
      final days = daysSmokeFree(DateTime.now().difference(quitDate));
      if (days <= 0) {
        return;
      }

      final db = ref.read(databaseProvider);
      final state = await db.timelineDao.getState();
      final acknowledged = _decode(state.acknowledgedMilestones);

      // The highest milestone reached and not yet acknowledged. Only one
      // fires, even if several were crossed while the app was closed.
      Milestone? pending;
      for (final milestone in Milestone.values) {
        if (days >= milestone.days && !acknowledged.contains(milestone.name)) {
          pending = milestone;
        }
      }
      if (pending == null || !mounted) {
        return;
      }

      // Written first, deliberately: if the dialog is dismissed by a system
      // event we would rather lose the celebration than repeat it forever.
      await db.timelineDao.setAcknowledgedMilestones(
        jsonEncode([...acknowledged, pending.name]),
      );
      if (!mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      await showMilestone(
        context,
        title: pending.title(l10n),
        detail: l10n.quitDatePassed(days),
      );
    } finally {
      _checking = false;
    }
  }

  List<String> _decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is List ? decoded.cast<String>() : const [];
    } on FormatException {
      // A corrupt value must not stop the app; it only means the next
      // milestone is celebrated again.
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-check whenever the quit date changes, so setting one today does not
    // wait for the next cold start.
    ref.listen(cessationStateProvider, (_, _) => _check());
    return const SizedBox.shrink();
  }
}
