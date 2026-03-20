import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth_service.dart';
import '../l10n/l10n_ext.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String oobCode;

  const ResetPasswordScreen({super.key, required this.oobCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();
  bool _pwVisible = false;
  bool _loading = false;
  bool _success = false;

  final RegExp _specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp _digitRegex = RegExp(r'\d');

  @override
  void dispose() {
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    setState(() => _loading = true);
    try {
      await AuthService().confirmPasswordReset(
        oobCode: widget.oobCode,
        newPassword: _pwCtrl.text,
      );
      if (!mounted) return;
      setState(() => _success = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.settingsError}: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: _success ? _buildSuccess(context, theme, l10n) : _buildForm(theme, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, dynamic l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.lock_reset_rounded,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.resetPasswordTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.resetPasswordSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _pwCtrl,
            obscureText: !_pwVisible,
            decoration: InputDecoration(
              labelText: l10n.settingsNewPassword,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _pwVisible = !_pwVisible),
                icon: Icon(
                  _pwVisible ? Icons.visibility_off : Icons.visibility,
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _pw2Ctrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.authConfirmPasswordHint,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.authConfirmPasswordRequired;
              if (v != _pwCtrl.text) return l10n.authPasswordMismatch;
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.resetPasswordSave),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, ThemeData theme, dynamic l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 64,
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        Text(
          l10n.resetPasswordSuccessTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.resetPasswordSuccessBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => context.go('/login'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(l10n.resetPasswordGoToLogin),
        ),
      ],
    );
  }
}
