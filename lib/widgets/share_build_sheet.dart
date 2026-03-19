import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';

class ShareBuildSheet extends StatefulWidget {
  const ShareBuildSheet({
    super.key,
    required this.build,
    required this.senderName,
    required this.repo,
  });

  final SavedBuild build;
  final String senderName;
  final BuildsRepository repo;

  @override
  State<ShareBuildSheet> createState() => _ShareBuildSheetState();
}

class _ShareBuildSheetState extends State<ShareBuildSheet> {
  bool _readOnly = false;
  String? _shareUrl;
  bool _isGenerating = false;
  String? _error;
  int _genSeq = 0;

  @override
  void initState() {
    super.initState();
    _generateLink(minDuration: Duration.zero);
  }

  Future<void> _generateLink({
    Duration minDuration = const Duration(milliseconds: 600),
  }) async {
    final seq = ++_genSeq;
    final readOnly = _readOnly;
    setState(() {
      _isGenerating = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        widget.repo.publishBuild(
          widget.build,
          readOnly: readOnly,
          senderName: readOnly ? widget.senderName : null,
        ),
        Future<void>.delayed(minDuration),
      ]);
      if (mounted && seq == _genSeq) {
        setState(() {
          _shareUrl = results[0] as String;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted && seq == _genSeq) {
        setState(() {
          _isGenerating = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(context.l10n.shareCouldNotOpen),
          ),
        );
      }
    }
  }

  Future<void> _copy(BuildContext context) async {
    final url = _shareUrl;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.sharedLinkCopied),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final shareUrl = _shareUrl ?? '';
    final buildTitle = widget.build.title;

    final encodedText = shareUrl.isEmpty
        ? ''
        : Uri.encodeComponent(l10n.shareMessageText(buildTitle, shareUrl));
    final encodedSubject = Uri.encodeComponent(l10n.shareEmailSubject(buildTitle));

    final channels = shareUrl.isEmpty
        ? <(String, Widget, Widget, String, bool)>[]
        : <(String, Widget, Widget, String, bool)>[
            (
              'WhatsApp',
              const FaIcon(FontAwesomeIcons.whatsapp,
                  color: Colors.white, size: 26),
              const ColoredBox(color: Color(0xFF25D366)),
              'https://wa.me/?text=$encodedText',
              false,
            ),
            (
              'Instagram',
              const FaIcon(FontAwesomeIcons.instagram,
                  color: Colors.white, size: 26),
              const Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.6, 1.0),
                        radius: 2.2,
                        colors: [
                          Color(0xFFFFDC80),
                          Color(0xFFF77737),
                          Color(0xFFF56040),
                          Color(0xFFE1306C),
                          Color(0xFFCE2085),
                        ],
                        stops: [0.0, 0.20, 0.35, 0.55, 1.0],
                      ),
                    ),
                    child: SizedBox.expand(),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 0.6),
                        colors: [
                          Color(0xCC7B1FA2),
                          Color(0x007B1FA2),
                        ],
                      ),
                    ),
                    child: SizedBox.expand(),
                  ),
                ],
              ),
              'instagram://direct-inbox',
              true,
            ),
            (
              'X',
              const FaIcon(FontAwesomeIcons.xTwitter,
                  color: Colors.white, size: 24),
              const ColoredBox(color: Colors.black),
              'https://twitter.com/intent/tweet?text=$encodedText',
              false,
            ),
            (
              'E-Mail',
              const Icon(Icons.email_rounded, color: Colors.white, size: 26),
              const ColoredBox(color: Color(0xFF78909C)),
              'mailto:?subject=$encodedSubject&body=$encodedText',
              false,
            ),
            (
              'SMS',
              const Icon(Icons.sms_rounded, color: Colors.white, size: 26),
              const ColoredBox(color: Color(0xFF34AADC)),
              'sms:?&body=$encodedText',
              false,
            ),
          ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.shareTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.shareReadOnly,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                Switch(
                  value: _readOnly,
                  onChanged: _isGenerating
                      ? null
                      : (v) {
                          setState(() => _readOnly = v);
                          _generateLink();
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _isGenerating && _shareUrl == null
                        ? Row(
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                l10n.shareGenerating,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          )
                        : _error != null && _shareUrl == null
                            ? Text(
                                l10n.shareGeneratingError,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              )
                            : Text(
                                shareUrl,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: _isGenerating ? 0.45 : 1.0,
                                  ),
                                ),
                              ),
                  ),
                  const SizedBox(width: 8),
                  if (_isGenerating && _shareUrl != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    FilledButton.icon(
                      onPressed: shareUrl.isEmpty ? null : () => _copy(context),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(l10n.shareCopy),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
            if (channels.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.shareDirectSection,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              IgnorePointer(
                ignoring: _isGenerating,
                child: AnimatedOpacity(
                  opacity: _isGenerating ? 0.35 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: channels.map((c) {
                      final (label, iconWidget, bgWidget, url, copyFirst) = c;
                      return InkWell(
                        onTap: () async {
                          if (copyFirst) {
                            await Clipboard.setData(
                                ClipboardData(text: shareUrl));
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(context.l10n.shareInstagramCopied),
                              ),
                            );
                          }
                          if (context.mounted) _launch(context, url);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      bgWidget,
                                      Center(child: iconWidget),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                label,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
