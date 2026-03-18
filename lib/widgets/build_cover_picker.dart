import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _previewPrefix = 'assets/images/previews/';

/// Horizontal scrollable strip for picking a build cover.
/// Discovers available images dynamically via AssetManifest.
/// [selectedCoverId] is the full asset path, or null for no cover.
class BuildCoverPicker extends StatefulWidget {
  const BuildCoverPicker({
    super.key,
    required this.selectedCoverId,
    required this.onChanged,
  });

  final String? selectedCoverId;
  final ValueChanged<String?> onChanged;

  @override
  State<BuildCoverPicker> createState() => _BuildCoverPickerState();
}

class _BuildCoverPickerState extends State<BuildCoverPicker> {
  List<String>? _paths;

  @override
  void initState() {
    super.initState();
    _loadPaths();
  }

  Future<void> _loadPaths() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith(_previewPrefix))
        .toList()
      ..sort();
    if (mounted) setState(() => _paths = paths);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paths = _paths;

    if (paths == null) {
      return const SizedBox(height: 72, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    final items = <String?>[null, ...paths];

    return SizedBox(
      height: 72,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _CoverTile(
                assetPath: items[i],
                isSelected: items[i] == widget.selectedCoverId,
                theme: theme,
                onTap: () => widget.onChanged(items[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CoverTile extends StatelessWidget {
  const _CoverTile({
    required this.assetPath,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  final String? assetPath;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (assetPath == null)
                _DefaultGradient(theme: theme)
              else
                Image.asset(assetPath!, fit: BoxFit.cover),
              if (assetPath == null)
                Center(
                  child: Icon(
                    Icons.hide_image_outlined,
                    size: 26,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (isSelected)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.check_rounded, size: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultGradient extends StatelessWidget {
  const _DefaultGradient({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.24),
            theme.colorScheme.tertiary.withValues(alpha: 0.20),
            theme.colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
    );
  }
}

/// Renders the cover thumbnail used inside BuildListCard.
/// [coverId] is the full asset path (e.g. 'assets/images/previews/foo.png'),
/// or null for the default gradient.
class BuildCoverThumbnail extends StatelessWidget {
  const BuildCoverThumbnail({
    super.key,
    required this.coverId,
    required this.width,
    required this.height,
  });

  final String? coverId;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (coverId == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.24),
              theme.colorScheme.tertiary.withValues(alpha: 0.20),
              theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          coverId!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.24),
                  theme.colorScheme.tertiary.withValues(alpha: 0.20),
                  theme.colorScheme.surfaceContainerHighest,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
