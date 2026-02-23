import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth_service.dart';

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

  bool _isLogin = true;
  bool _pwVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final email = _emailCtrl.text.trim();
      final pw = _pwCtrl.text;

      if (_isLogin) {
        await _auth.signInWithEmailPassword(email: email, password: pw);
      } else {
        await _auth.registerWithEmailPassword(email: email, password: pw);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin ? 'Login erfolgreich' : 'Registrierung erfolgreich',
          ),
        ),
      );
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib oben eine gültige E-Mail ein.'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wenn ein Konto existiert, wurde eine E-Mail gesendet.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

                  // Logo/Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.memory,
                      color: theme.colorScheme.primary,
                      size: 28,
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
                    'Forge your ultimate battlestation',
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
                          color: Colors.black.withOpacity(0.06),
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
                                'Email Address',
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email),
                                  hintText: 'name@example.com',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty)
                                    return 'Bitte E-Mail eingeben.';
                                  if (!value.contains('@'))
                                    return 'Ungültige E-Mail.';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  if (_isLogin)
                                    TextButton(
                                      onPressed: _loading
                                          ? null
                                          : _forgotPassword,
                                      child: const Text('Forgot?'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _pwCtrl,
                                obscureText: !_pwVisible,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
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
                                  if (value.isEmpty)
                                    return 'Bitte Passwort eingeben.';
                                  if (value.length < 6)
                                    return 'Mind. 6 Zeichen.';
                                  return null;
                                },
                              ),

                              if (!_isLogin) ...[
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _pw2Ctrl,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(),
                                    hintText: 'Confirm password',
                                  ),
                                  validator: (v) {
                                    final value = v ?? '';
                                    if (value.isEmpty)
                                      return 'Bitte Passwort bestätigen.';
                                    if (value != _pwCtrl.text) {
                                      return 'Passwörter stimmen nicht überein.';
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
                                        ? 'Enter BuildMyPC'
                                        : 'Create Account',
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
                                      'OR CONNECT USING',
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
                                          : () {
                                              // TODO: Google Sign-In
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Google Sign-In (Demo)',
                                                  ),
                                                ),
                                              );
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
                            try {
                              await _auth.signInAnonymously();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Als Gast fortgefahren'),
                                ),
                              );
                              context.go('/configure');
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceFirst(
                                      'Exception: ',
                                      '',
                                    ),
                                  ),
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    child: const Text('Continue as Guest →'),
                  ),

                  const SizedBox(height: 6),

                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'By signing in, you agree to our ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/terms'),
                        child: const Text('Terms of Service'),
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
                  color: Colors.black.withOpacity(0.10),
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
