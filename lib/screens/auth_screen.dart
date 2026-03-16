import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth_service.dart';
import '../l10n/l10n_ext.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();
  final _auth = AuthService();
  final Map<String, int> _failedLoginAttempts = <String, int>{};
  final Set<String> _resetRequiredEmails = <String>{};

  bool _isLogin = true;
  bool _pwVisible = false;
  bool _loading = false;
  final RegExp _specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp _digitRegex = RegExp(r'\d');
  static const int _maxPasswordAttempts = 3;

  bool _isInvalidCredentialCode(String code) =>
      code == 'wrong-password' || code == 'invalid-credential';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = context.l10n;
    final email = _emailCtrl.text.trim().toLowerCase();
    final pw = _pwCtrl.text;

    if (_isLogin && _resetRequiredEmails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authResetRequiredAfterFailedLogins)),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await _auth.signInWithEmailPassword(email: email, password: pw);
        _failedLoginAttempts.remove(email);
        _resetRequiredEmails.remove(email);
      } else {
        await _auth.registerWithEmailPassword(email: email, password: pw);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin ? l10n.authLoginSuccess : l10n.authRegisterSuccess,
          ),
        ),
      );
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;

      if (_isLogin &&
          e is AuthServiceException &&
          _isInvalidCredentialCode(e.code)) {
        _pwCtrl.clear();
        final failedAttempts = (_failedLoginAttempts[email] ?? 0) + 1;
        _failedLoginAttempts[email] = failedAttempts;

        if (failedAttempts >= _maxPasswordAttempts) {
          _resetRequiredEmails.add(email);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.authResetRequiredAfterFailedLogins)),
          );
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim().toLowerCase();
    final l10n = context.l10n;

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authForgotPasswordValid)),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _failedLoginAttempts.remove(email);
      _resetRequiredEmails.remove(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authForgotPasswordSent)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Logo
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 64,
                                spreadRadius: 8,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: const Color(0xFF7C3AED).withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: 0.55,
                                ),
                                blurRadius: 100,
                                spreadRadius: 25,
                              ),
                            ],
                    ),
                    child: Image.asset(
                      'assets/images/futuristic.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.memory,
                        color: theme.colorScheme.primary,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Brand
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'BuildMy',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        TextSpan(
                          text: 'PC',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.authTagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  // Card
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Segmented Login/Register
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SegmentButton(
                                  label: 'Login',
                                  selected: _isLogin,
                                  onTap: _loading
                                      ? null
                                      : () => setState(() => _isLogin = true),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _SegmentButton(
                                  label: 'Register',
                                  selected: !_isLogin,
                                  onTap: _loading
                                      ? null
                                      : () => setState(() => _isLogin = false),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.authEmailLabel,
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.alternate_email),
                                  hintText: l10n.authEmailHint,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) {
                                    return l10n.authEmailRequired;
                                  }
                                  if (!value.contains('@')) {
                                    return l10n.authEmailInvalid;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.authPasswordLabel,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  if (_isLogin)
                                    TextButton(
                                      onPressed: _loading
                                          ? null
                                          : _forgotPassword,
                                      child: Text(l10n.authForgot),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _pwCtrl,
                                obscureText: !_pwVisible,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  if (!_loading) _submit();
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  errorMaxLines: 3,
                                  suffixIcon: IconButton(
                                    onPressed: _loading
                                        ? null
                                        : () => setState(
                                            () => _pwVisible = !_pwVisible,
                                          ),
                                    icon: Icon(
                                      _pwVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  final value = v ?? '';
                                  if (value.isEmpty) {
                                    return l10n.authPasswordRequired;
                                  }
                                  if (!_isLogin &&
                                      (value.length < 8 ||
                                          !_specialCharRegex.hasMatch(value) ||
                                          !_uppercaseRegex.hasMatch(value) ||
                                          !_digitRegex.hasMatch(value))) {
                                    return l10n.authPasswordMinLength;
                                  }
                                  return null;
                                },
                              ),

                              if (!_isLogin) ...[
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _pw2Ctrl,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    border: const OutlineInputBorder(),
                                    hintText: l10n.authConfirmPasswordHint,
                                  ),
                                  validator: (v) {
                                    final value = v ?? '';
                                    if (value.isEmpty) {
                                      return l10n.authConfirmPasswordRequired;
                                    }
                                    if (value != _pwCtrl.text) {
                                      return l10n.authPasswordMismatch;
                                    }
                                    return null;
                                  },
                                ),
                              ],

                              const SizedBox(height: 18),

                              SizedBox(
                                height: 50,
                                child: FilledButton.icon(
                                  onPressed: _loading ? null : _submit,
                                  icon: _loading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.power_settings_new),
                                  label: Text(
                                    _isLogin
                                        ? l10n.authEnterApp
                                        : l10n.authCreateAccount,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      l10n.authOrConnect,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Provider buttons (Google etc.)
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _loading
                                          ? null
                                          : () async {
                                              setState(() => _loading = true);
                                              final l10n = context.l10n;
                                              try {
                                                await _auth.signInWithGoogle();
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      l10n.authGoogleSuccess),
                                                ));
                                                context.go('/dashboard');
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(e
                                                      .toString()
                                                      .replaceFirst(
                                                          'Exception: ', '')),
                                                ));
                                              } finally {
                                                if (mounted) {
                                                  setState(
                                                      () => _loading = false);
                                                }
                                              }
                                            },
                                      child: const Text('Google'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _loading ? null : () {},
                                      child: const Text('Apple'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _loading ? null : () {},
                                      child: const Text('GitHub'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            final l10n = context.l10n;
                            try {
                              await _auth.signInAnonymously();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(l10n.authGuestSuccess)),
                              );
                              context.go('/configure');
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceFirst('Exception: ', '')),
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    child: Text(l10n.authGuest),
                  ),

                  const SizedBox(height: 6),

                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.authTermsAgreement,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/terms'),
                        child: Text(l10n.authTermsLink),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
