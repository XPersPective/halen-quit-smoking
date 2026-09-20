import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../l10n/generated/app_localizations.dart';

const _sourceUri = 'https://github.com/XPersPective/halen-quit-smoking';
const _licenseUri =
    'https://github.com/XPersPective/halen-quit-smoking/blob/master/LICENSE';
const _privacyUri =
    'https://github.com/XPersPective/halen-quit-smoking/blob/master/PRIVACY_POLICY.md';
const _supportUri = 'https://github.com/XPersPective/halen-quit-smoking/issues';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(BuildContext context, String value) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await launchUrl(
          Uri.parse(value),
          mode: LaunchMode.externalApplication,
        ) &&
        context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.aboutOpenLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(HalenSpace.x6),
        children: [
          Icon(Icons.eco_outlined, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: HalenSpace.x3),
          Text(
            'Halen',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: HalenSpace.x4),
          Text(l10n.aboutIntro),
          const SizedBox(height: HalenSpace.x5),
          Text(l10n.aboutOpenSourceTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: HalenSpace.x1),
          Text(l10n.aboutOpenSourceBody),
          const SizedBox(height: HalenSpace.x5),
          Text(l10n.aboutPrivacyTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: HalenSpace.x1),
          Text(l10n.aboutPrivacyBody),
          const SizedBox(height: HalenSpace.x4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.code),
            title: Text(l10n.aboutSourceCode),
            onTap: () => _open(context, _sourceUri),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.aboutLicense),
            onTap: () => _open(context, _licenseUri),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.aboutPrivacyPolicy),
            onTap: () => _open(context, _privacyUri),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.forum_outlined),
            title: Text(l10n.aboutSupport),
            onTap: () => _open(context, _supportUri),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.aboutThirdPartyLicenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Halen',
              applicationLegalese: l10n.aboutOpenSourceBody,
            ),
          ),
        ],
      ),
    );
  }
}
