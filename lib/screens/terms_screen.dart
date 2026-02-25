import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n_ext.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsTitle),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          _section(theme, l10n.termsSection1Title, l10n.termsSection1Body),
          _section(theme, l10n.termsSection2Title, l10n.termsSection2Body),
          _section(theme, l10n.termsSection3Title, l10n.termsSection3Body),
          _section(theme, l10n.termsSection4Title, l10n.termsSection4Body),
          _section(theme, l10n.termsSection5Title, l10n.termsSection5Body),
          _section(theme, l10n.termsSection6Title, l10n.termsSection6Body),
          _section(theme, l10n.termsSection7Title, l10n.termsSection7Body),
          _section(theme, l10n.termsSection8Title, l10n.termsSection8Body),
          const SizedBox(height: 8),
          Text(
            l10n.termsDate,
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
