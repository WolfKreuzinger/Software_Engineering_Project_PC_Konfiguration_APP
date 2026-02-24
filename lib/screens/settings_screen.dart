import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/language_global.dart';
import '../theme/theme_global.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAuthed(User? u) => u != null && !u.isAnonymous;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final authed = _isAuthed(user);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        // ── Profil ──────────────────────────────────────────────────────
        _buildProfileCard(context, theme, user, authed),
        const SizedBox(height: 24),

        // ── Darstellung ─────────────────────────────────────────────────
        _sectionLabel(theme, 'Darstellung'),
        const SizedBox(height: 10),
        _buildAppearanceCard(theme),
        const SizedBox(height: 24),

        // ── Sprache ──────────────────────────────────────────────────────
        _sectionLabel(theme, 'Sprache'),
        const SizedBox(height: 10),
        _buildLanguageCard(theme),
        const SizedBox(height: 24),

        // ── Konto & Sicherheit (nur wenn eingeloggt) ─────────────────────
        if (authed) ...[
          _sectionLabel(theme, 'Konto & Sicherheit'),
          const SizedBox(height: 10),
          _buildAccountCard(context, theme, user!),
          const SizedBox(height: 24),
        ],

        // ── Rechtliches & Support ────────────────────────────────────────
        _sectionLabel(theme, 'Rechtliches & Support'),
        const SizedBox(height: 10),
        _buildLegalCard(context, theme),
        const SizedBox(height: 20),

        Text(
          'BuildMyPC v1.0.0',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  // ── Section label ────────────────────────────────────────────────────────

  Widget _sectionLabel(ThemeData theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  // ── Profile Card ─────────────────────────────────────────────────────────

  Widget _buildProfileCard(
    BuildContext context,
    ThemeData theme,
    User? user,
    bool authed,
  ) {
    final displayName =
        user?.displayName ?? user?.email?.split('@').first ?? 'Gast';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Name + E-Mail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authed ? displayName : 'Gast',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    authed ? (user?.email ?? '') : 'Nicht eingeloggt',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Action button
            if (authed)
              TextButton(
                onPressed: () => _showEditAccountSheet(context, user!),
                child: Text(
                  'Bearbeiten',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              FilledButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login'),
              ),
          ],
        ),
      ),
    );
  }

  // ── Appearance Card ──────────────────────────────────────────────────────

  Widget _buildAppearanceCard(ThemeData theme) {
    final isDark = themeController.mode == ThemeMode.dark;
    return Card(
      child: _SettingsTile(
        icon: Icons.brightness_6_outlined,
        iconBgColor: Colors.indigo.withValues(alpha: 0.1),
        iconColor: theme.colorScheme.primary,
        title: 'Theme',
        trailing: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SegmentButton(
                label: 'Hell',
                selected: !isDark,
                onTap: () =>
                    setState(() => themeController.setMode(ThemeMode.light)),
              ),
              _SegmentButton(
                label: 'Dunkel',
                selected: isDark,
                onTap: () =>
                    setState(() => themeController.setMode(ThemeMode.dark)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Language Card ─────────────────────────────────────────────────────────

  Widget _buildLanguageCard(ThemeData theme) {
    final isDE = languageController.locale.languageCode == 'de';
    return Card(
      child: _SettingsTile(
        icon: Icons.language_rounded,
        iconBgColor: Colors.teal.withValues(alpha: 0.1),
        iconColor: Colors.teal.shade700,
        title: 'Sprache',
        trailing: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SegmentButton(
                label: 'Deutsch',
                selected: isDE,
                onTap: () => setState(
                  () => languageController.setLocale(const Locale('de')),
                ),
              ),
              _SegmentButton(
                label: 'English',
                selected: !isDE,
                onTap: () => setState(
                  () => languageController.setLocale(const Locale('en')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Account Card ─────────────────────────────────────────────────────────

  Widget _buildAccountCard(
    BuildContext context,
    ThemeData theme,
    User user,
  ) {
    return Card(
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            iconBgColor: Colors.orange.withValues(alpha: 0.1),
            iconColor: Colors.orange.shade700,
            title: 'Passwort ändern',
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => _showPasswordResetDialog(context, user),
          ),
          _divider(theme),
          _SettingsTile(
            icon: Icons.logout_rounded,
            iconBgColor: Colors.red.withValues(alpha: 0.1),
            iconColor: Colors.red,
            title: 'Abmelden',
            titleColor: Colors.red,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
    );
  }

  // ── Legal Card ───────────────────────────────────────────────────────────

  Widget _buildLegalCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          _SettingsTile(
            title: 'Datenschutzerklärung',
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.go('/privacy'),
          ),
          _divider(theme),
          _SettingsTile(
            title: 'Nutzungsbedingungen',
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.go('/terms'),
          ),
          _divider(theme),
          _SettingsTile(
            title: 'Support kontaktieren',
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.go('/support'),
          ),
        ],
      ),
    );
  }

  Divider _divider(ThemeData theme) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: theme.dividerColor.withValues(alpha: 0.5),
      );

  // ── Edit Account Bottom Sheet ─────────────────────────────────────────────

  void _showEditAccountSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditAccountSheet(
        user: user,
        onSaved: () => setState(() {}),
      ),
    );
  }

  // ── Password Reset Dialog ─────────────────────────────────────────────────

  void _showPasswordResetDialog(BuildContext context, User user) {
    final hasEmailProvider =
        user.providerData.any((p) => p.providerId == 'password');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Passwort zurücksetzen'),
        content: Text(
          hasEmailProvider
              ? 'Wir senden eine E-Mail zum Zurücksetzen des Passworts an:\n\n${user.email}'
              : 'Dein Konto ist mit Google verknüpft.\nBitte verwalte dein Passwort über dein Google-Konto.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          if (hasEmailProvider)
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: user.email!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwort-Reset-E-Mail wurde gesendet.'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fehler: $e')),
                    );
                  }
                }
              },
              child: const Text('E-Mail senden'),
            ),
        ],
      ),
    );
  }
}

// ── Reusable tile ────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final Color? iconBgColor;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    this.icon,
    this.iconBgColor,
    this.iconColor,
    required this.title,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBgColor ?? Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? theme.iconTheme.color,
                ),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

// ── Segmented toggle button ──────────────────────────────────────────────────

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Edit Account Bottom Sheet ────────────────────────────────────────────────

class _EditAccountSheet extends StatefulWidget {
  final User user;
  final VoidCallback onSaved;

  const _EditAccountSheet({required this.user, required this.onSaved});

  @override
  State<_EditAccountSheet> createState() => _EditAccountSheetState();
}

class _EditAccountSheetState extends State<_EditAccountSheet> {
  late final TextEditingController _nameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await widget.user.updateDisplayName(name);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Profil bearbeiten',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Display name field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Anzeigename',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),

          // Email (read-only)
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'E-Mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
            ),
            controller:
                TextEditingController(text: widget.user.email ?? ''),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
