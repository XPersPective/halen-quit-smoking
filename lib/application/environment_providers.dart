import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/environment_impact.dart';
import 'module_providers.dart';

/// Cigarettes not smoked and money not spent, for the environment card.
class EnvironmentView {
  const EnvironmentView({required this.impact, required this.saved});

  final EnvironmentImpact impact;
  final double saved;
}

/// Avoided cigarettes come from the same [SavingsLedger] as the money
/// figure: completed days the user actually logged, against the baseline.
/// Empty days are unknown, not "all avoided" — that bug once produced
/// "1795 butts spared" on the first day.
final environmentProvider = Provider<AsyncValue<EnvironmentView>>((ref) {
  final economy = ref.watch(economyProvider).value;
  return ref.watch(savingsLedgerProvider).whenData((ledger) {
    return EnvironmentView(
      impact: EnvironmentImpact(cigarettesAvoided: ledger.avoided),
      saved: economy?.saved(ledger.avoided) ?? 0,
    );
  });
});
