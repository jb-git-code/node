import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:node/shared/models/post.dart';

class ExpandBlogCard extends StatefulWidget {
  const ExpandBlogCard({super.key, required this.post, this.heroTag});

  final Post post;

  /// Pass the same tag that the small blog card uses in its Hero,
  /// and the card will visually grow into this page.
  final Object? heroTag;

  @override
  State<ExpandBlogCard> createState() => _ExpandBlogCardState();
}

class _ExpandBlogCardState extends State<ExpandBlogCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final author = widget.post.authorName;

    // The big card. Same look as the small card (surface + border + radius),
    // just taller, so it reads as the same object expanded.
    final card = Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.post.title,
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colors.surfaceContainerHigh,
                        child: Text(
                          author.isNotEmpty ? author[0].toUpperCase() : '?',
                          style: text.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: colors.outline),
                  const SizedBox(height: 20),

                  // Full description
                  Text(
                    widget.post.description,
                    style: text.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom action bar ──
          Divider(height: 1, color: colors.outline),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // Save toggle
                TextButton.icon(
                  onPressed: () => setState(() => _saved = !_saved),
                  style: TextButton.styleFrom(
                    foregroundColor: _saved
                        ? colors.onPrimary
                        : colors.onSurface,
                    backgroundColor: _saved ? colors.primary : null,
                  ),
                  icon: const Icon(LucideIcons.star, size: 18),
                  label: Text(_saved ? 'Saved' : 'Save'),
                ),
                const Spacer(),
                // Collapse back to the small card
                TextButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(LucideIcons.chevronDownSquare, size: 18),
                  label: const Text('Collapse'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: widget.heroTag == null
            ? card
            : Hero(tag: widget.heroTag!, child: card),
      ),
    );
  }
}
