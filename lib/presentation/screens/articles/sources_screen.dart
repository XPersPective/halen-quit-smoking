import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// Every source behind the app's claims, in one list (module report §11.③).
///
/// Nobody else in the category ships this, and it is aimed squarely at the
/// user who wants to check the homework rather than be told to trust it. The
/// URLs are copyable rather than launched: the app makes no network calls of
/// its own, and that promise is worth more than a tap saved.
class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final sources = [
      ...ref.watch(dailyCardRepositoryProvider).allSources(),
      for (final technique in ref.watch(libraryRepositoryProvider).sosTechniques())
        (label: technique.name('en'), url: technique.sourceUrl),
      for (final organ in ref.watch(libraryRepositoryProvider).organs())
        (label: organ.name('en'), url: organ.sourceUrl),
    ];
    final seen = <String>{};
    final unique = [
      for (final source in sources)
        if (seen.add(source.url)) source,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sourcesTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(HalenSpace.x5),
        itemCount: unique.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.sourcesIntro,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          final source = unique[index - 1];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(source.label),
            subtitle: Text(source.url, style: theme.textTheme.labelSmall),
            trailing: const Icon(Icons.copy_rounded, size: 18),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: source.url));
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.commonDone)),
              );
            },
          );
        },
      ),
    );
  }
}
