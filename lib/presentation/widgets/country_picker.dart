import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/country_providers.dart';
import '../../core/design/tokens.dart';
import '../../domain/countries.dart';
import '../../l10n/generated/app_localizations.dart';

/// Name tables for the current UI language, most specific first.
List<String> countryNameChain(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return CountryDirectory.tagChain(
    locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  );
}

/// Opens the searchable country list and returns the ISO code picked, or
/// null when dismissed.
Future<String?> pickCountry(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _CountrySheet(),
  );
}

class _CountrySheet extends ConsumerStatefulWidget {
  const _CountrySheet();

  @override
  ConsumerState<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends ConsumerState<_CountrySheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final directory = ref.watch(countryDirectoryProvider).value;
    final selected = ref.watch(countryCodeProvider);
    final chain = countryNameChain(context);
    final height = MediaQuery.sizeOf(context).height * 0.8;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HalenSpace.x5,
                0,
                HalenSpace.x5,
                HalenSpace.x3,
              ),
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: l10n.countrySearchHint,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: directory == null
                  ? const Center(child: CircularProgressIndicator())
                  : _list(directory, chain, selected),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(
    CountryDirectory directory,
    List<String> chain,
    String? selected,
  ) {
    final results = directory.search(_query, chain);
    if (results.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.countryNoMatch),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final country = results[i];
        return ListTile(
          title: Text(country.name),
          trailing: country.code == selected
              ? const Icon(Icons.check_rounded)
              : Text(
                  country.code,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
          onTap: () => Navigator.of(context).pop(country.code),
        );
      },
    );
  }
}
