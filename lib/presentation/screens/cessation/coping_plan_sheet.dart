import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/cessation.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'quit_plan_screen.dart' show triggerLabelText;

/// The relapse-prevention plan (premium brief §C.3).
///
/// Written *before* the moment, because deciding inside a craving is the
/// part that fails. The form opens pre-seeded with the triggers the person
/// already named at onboarding — an empty relapse-prevention form is one
/// nobody ever fills in, and that is why most apps that have one might as
/// well not.
Future<void> showCopingPlanSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HalenRadius.large),
        ),
      ),
      builder: (_) => const _CopingPlanSheet(),
    );

class _CopingPlanSheet extends ConsumerWidget {
  const _CopingPlanSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final triggers = ref.watch(highRiskTriggersProvider).value ?? const [];
    final plans = ref.watch(cessationStateProvider).value?.copingPlans ??
        const <CopingPlan>[];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: HalenSpace.screen,
          children: [
            Text(l10n.copingTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: HalenSpace.x2),
            Text(l10n.copingLead, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x5),
            for (final trigger in triggers)
              _CopingField(
                trigger: trigger,
                initial: plans
                    .where((p) => p.trigger == trigger)
                    .map((p) => p.plan)
                    .firstOrNull,
              ),
          ],
        ),
      ),
    );
  }
}

class _CopingField extends ConsumerStatefulWidget {
  const _CopingField({required this.trigger, this.initial});

  final TriggerLabel trigger;
  final String? initial;

  @override
  ConsumerState<_CopingField> createState() => _CopingFieldState();
}

class _CopingFieldState extends ConsumerState<_CopingField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial ?? '');
  bool _saved = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(cessationControllerProvider)
        .saveCopingPlan(widget.trigger, _controller.text);
    setState(() => _saved = _controller.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: HalenSpace.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  triggerLabelText(widget.trigger, l10n),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              if (_saved)
                Text(
                  l10n.copingSaved,
                  style: theme.textTheme.labelSmall,
                ),
            ],
          ),
          const SizedBox(height: HalenSpace.x2),
          TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(hintText: l10n.copingHint),
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              if (_saved) {
                setState(() => _saved = false);
              }
            },
            onSubmitted: (_) => _save(),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
              _save();
            },
          ),
        ],
      ),
    );
  }
}
