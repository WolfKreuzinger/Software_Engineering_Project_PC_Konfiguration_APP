import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n_ext.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Stack(
            children: [
              // Background glow
              Positioned(
                top: -80,
                left: size.width * 0.5 - 180,
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: isDark ? 0.22 : 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 56),

                    // ── Logo ──────────────────────────────────────
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
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.computer_rounded,
                          size: 120,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── App name ──────────────────────────────────
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                          height: 1.0,
                        ),
                        children: [
                          TextSpan(
                            text: 'BuildMy',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: 'PC',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Subtitle ──────────────────────────────────
                    Text(
                      l10n.authTagline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 52),

                    // ── Divider with label ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                              children: () {
                                final s = l10n.homeWelcome;
                                final i = s.lastIndexOf('PC');
                                return [
                                  TextSpan(text: s.substring(0, i)),
                                  TextSpan(
                                    text: 'PC',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  if (i + 2 < s.length)
                                    TextSpan(text: s.substring(i + 2)),
                                ];
                              }(),
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

                    const SizedBox(height: 28),

                    // ── Configure button ──────────────────────────
                    _HomeButton(
                      icon: Icons.build_circle_rounded,
                      label: l10n.homeConfigureButton,
                      description: l10n.homeSubtitle,
                      isPrimary: true,
                      onTap: () => context.go('/configure'),
                    ),

                    const SizedBox(height: 14),

                    // ── Login button ──────────────────────────────
                    _HomeButton(
                      icon: Icons.login_rounded,
                      label: l10n.homeLoginButton,
                      description: '',
                      isPrimary: false,
                      onTap: () => context.go('/login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 20),
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
