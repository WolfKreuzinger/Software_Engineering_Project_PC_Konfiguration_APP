import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth_service.dart';
import '../l10n/l10n_ext.dart';
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
    final l10n = context.l10n;
    final user = FirebaseAuth.instance.currentUser;
    final authed = _isAuthed(user);

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        // ── Profil ──────────────────────────────────────────────────────
        _buildProfileCard(context, theme, user, authed, l10n),
        const SizedBox(height: 24),

        // ── Darstellung / Appearance ─────────────────────────────────────
        _sectionLabel(theme, l10n.settingsAppearance),
        const SizedBox(height: 10),
        _buildAppearanceCard(context, theme, l10n),
        const SizedBox(height: 24),

        // ── Sprache / Language ────────────────────────────────────────────
        _sectionLabel(theme, l10n.settingsLanguage),
        const SizedBox(height: 10),
        _buildLanguageCard(context, theme, l10n),
        const SizedBox(height: 24),

        // ── Konto & Sicherheit (nur wenn eingeloggt) ─────────────────────
        if (authed) ...[
          _sectionLabel(theme, l10n.settingsAccountSecurity),
          const SizedBox(height: 10),
          _buildAccountCard(context, theme, user!, l10n),
          const SizedBox(height: 24),
        ],

        // ── Rechtliches & Support ─────────────────────────────────────────
        _sectionLabel(theme, l10n.settingsLegalSupport),
        const SizedBox(height: 10),
        _buildLegalCard(context, theme, l10n),
        const SizedBox(height: 20),

        Text(
          l10n.settingsVersion,
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
    AppLocalizations l10n,
  ) {
    final displayName =
        user?.displayName ??
        user?.email?.split('@').first ??
        l10n.settingsGuest;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 14, 16, 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.all(1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(998),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authed ? displayName : l10n.settingsGuest,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authed ? (user?.email ?? '') : l10n.settingsNotLoggedIn,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Action button
                if (authed)
                  TextButton(
                    onPressed: () => _showEditAccountSheet(context, user!),
                    child: Text(
                      l10n.settingsEdit,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  FilledButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.settingsLogin),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Appearance Card ──────────────────────────────────────────────────────

  Widget _buildAppearanceCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      child: _SettingsTile(
        icon: Icons.brightness_6_outlined,
        iconBgColor: Colors.indigo.withValues(alpha: 0.1),
        iconColor: theme.colorScheme.primary,
        title: l10n.settingsTheme,
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
                label: l10n.settingsLight,
                selected: !isDark,
                onTap: () =>
                    setState(() => themeController.setMode(ThemeMode.light)),
              ),
              _SegmentButton(
                label: l10n.settingsDark,
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

  Widget _buildLanguageCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final isDE = languageController.locale.languageCode == 'de';
    return Card(
      child: _SettingsTile(
        icon: Icons.language_rounded,
        iconBgColor: Colors.teal.withValues(alpha: 0.1),
        iconColor: Colors.teal.shade700,
        title: l10n.settingsLanguage,
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
                label: l10n.settingsGerman,
                selected: isDE,
                onTap: () => setState(
                  () => languageController.setLocale(const Locale('de')),
                ),
              ),
              _SegmentButton(
                label: l10n.settingsEnglish,
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
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            iconBgColor: Colors.orange.withValues(alpha: 0.1),
            iconColor: Colors.orange.shade700,
            title: l10n.settingsChangePassword,
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
            title: l10n.settingsSignOut,
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

  Widget _buildLegalCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        children: [
          _SettingsTile(
            title: l10n.settingsPrivacyPolicy,
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.push('/privacy'),
          ),
          _divider(theme),
          _SettingsTile(
            title: l10n.settingsTermsOfService,
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.push('/terms'),
          ),
          _divider(theme),
          _SettingsTile(
            title: l10n.settingsContactSupport,
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outlineVariant,
            ),
            onTap: () => context.push('/support'),
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
      builder: (_) =>
          _EditAccountSheet(user: user, onSaved: () => setState(() {})),
    );
  }

  // ── Password Change Dialog ────────────────────────────────────────────────

  void _showPasswordResetDialog(BuildContext context, User user) {
    final l10n = context.l10n;
    final hasEmailProvider = user.providerData.any(
      (p) => p.providerId == 'password',
    );

    if (!hasEmailProvider) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.settingsResetPassword),
          content: Text(l10n.settingsGoogleAccountNote),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.settingsCancel),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => _ChangePasswordDialog(user: user),
    );
  }
}

// ── Change Password Dialog ────────────────────────────────────────────────────

class _ChangePasswordDialog extends StatefulWidget {
  final User user;

  const _ChangePasswordDialog({required this.user});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _currentPwVisible = false;
  bool _newPwVisible = false;
  bool _loading = false;

  final RegExp _specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp _digitRegex = RegExp(r'\d');

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    setState(() => _loading = true);
    try {
      await AuthService().updatePassword(
        currentPassword: _currentPwCtrl.text,
        newPassword: _newPwCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsPasswordChanged)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.settingsError}: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsChangePassword),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentPwCtrl,
              obscureText: !_currentPwVisible,
              decoration: InputDecoration(
                labelText: l10n.settingsCurrentPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _currentPwVisible = !_currentPwVisible),
                  icon: Icon(
                    _currentPwVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty)
                  ? l10n.settingsCurrentPasswordRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _newPwCtrl,
              obscureText: !_newPwVisible,
              decoration: InputDecoration(
                labelText: l10n.settingsNewPassword,
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _newPwVisible = !_newPwVisible),
                  icon: Icon(
                    _newPwVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (v) {
                final value = v ?? '';
                if (value.isEmpty) return l10n.authPasswordRequired;
                if (value.length < 8 ||
                    !_specialCharRegex.hasMatch(value) ||
                    !_uppercaseRegex.hasMatch(value) ||
                    !_digitRegex.hasMatch(value)) {
                  return l10n.authPasswordMinLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPwCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.authConfirmPasswordHint,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty)
                  return l10n.authConfirmPasswordRequired;
                if (v != _newPwCtrl.text) return l10n.authPasswordMismatch;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.settingsCancel),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.settingsSave),
        ),
      ],
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
    _nameController = TextEditingController(
      text: widget.user.displayName ?? '',
    );
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
          SnackBar(content: Text('${context.l10n.settingsError}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
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
          Row(
            children: [
              Text(
                l10n.settingsEditProfile,
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

          // Display name
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.settingsDisplayName,
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
              labelText: l10n.settingsEmail,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
            ),
            controller: TextEditingController(text: widget.user.email ?? ''),
          ),
          const SizedBox(height: 24),

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
                  : Text(l10n.settingsSave),
            ),
          ),
        ],
      ),
    );
  }
}
