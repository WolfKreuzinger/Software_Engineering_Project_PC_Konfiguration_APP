import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n_ext.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyTitle),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          _section(theme, l10n.privacySection1Title, l10n.privacySection1Body),
          _section(theme, l10n.privacySection2Title, l10n.privacySection2Body),
          _section(theme, l10n.privacySection3Title, l10n.privacySection3Body),
          _section(theme, l10n.privacySection4Title, l10n.privacySection4Body),
          _section(theme, l10n.privacySection5Title, l10n.privacySection5Body),
          _section(theme, l10n.privacySection6Title, l10n.privacySection6Body),
          _section(theme, l10n.privacySection7Title, l10n.privacySection7Body),
          const SizedBox(height: 8),
          Text(
            l10n.privacyDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(ThemeData theme, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
