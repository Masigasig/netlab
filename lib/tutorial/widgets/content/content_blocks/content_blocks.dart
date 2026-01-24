import 'package:flutter/material.dart';

import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/tutorial/models/tutorial_content.dart';

class TextBlock extends StatelessWidget {
  final String content;

  const TextBlock({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        content,
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.6,
          color: cs.onSurface.withAlpha(204),
        ),
      ),
    );
  }
}

class ImageBlock extends StatelessWidget {
  final String imagePath;
  final String? imagePathDark;
  final String? imagePathLight;
  final String? title;

  const ImageBlock({
    super.key,
    required this.imagePath,
    this.imagePathDark,
    this.imagePathLight,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    String resolvedPath;
    if (isDarkMode && imagePathDark != null) {
      resolvedPath = imagePathDark!;
    } else if (!isDarkMode && imagePathLight != null) {
      resolvedPath = imagePathLight!;
    } else {
      resolvedPath = imagePath;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/$resolvedPath",
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: cs.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NumberedListBlock extends StatelessWidget {
  final List<String> items;
  final String? title;

  const NumberedListBlock({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: cs.onSurface.withAlpha(204),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class BulletListBlock extends StatelessWidget {
  final List<String> items;
  final String? title;

  const BulletListBlock({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 12, top: 8),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: cs.onSurface.withAlpha(204),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class NoteBlock extends StatelessWidget {
  final String content;
  final NoteType type;

  const NoteBlock({
    super.key,
    required this.content,
    this.type = NoteType.note,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final config = switch (type) {
      NoteType.note => (
        icon: Icons.info_outline,
        color: cs.primary,
        bgColor: cs.primaryContainer,
      ),
      NoteType.tip => (
        icon: Icons.lightbulb_outline,
        color: Colors.amber.shade700,
        bgColor: Colors.amber.shade50,
      ),
      NoteType.warning => (
        icon: Icons.warning_amber_outlined,
        color: Colors.orange.shade700,
        bgColor: Colors.orange.shade50,
      ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color.withAlpha(51)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(config.icon, size: 20, color: config.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.bodySmall.copyWith(
                height: 1.5,
                color: config.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum NoteType { note, tip, warning }

class DefinitionBlock extends StatelessWidget {
  final List<DefinitionItem> definitions;

  const DefinitionBlock({super.key, required this.definitions});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: definitions.map((def) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.onSurfaceVariant.withAlpha(77),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outline.withAlpha(51)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.term,
                  style: AppTextStyles.subtitleLarge.copyWith(
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  def.definition,
                  style: AppTextStyles.bodySmall.copyWith(
                    height: 1.5,
                    color: cs.onSurface.withAlpha(204),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TableBlock extends StatelessWidget {
  final List<List<String>> rows;
  final String? title;

  const TableBlock({super.key, required this.rows, this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (rows.isEmpty) return const SizedBox.shrink();

    final headers = rows.first;
    final dataRows = rows.skip(1).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: cs.outline.withAlpha(51)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withAlpha(128),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: headers.map((header) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            header,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ...dataRows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final isLast = index == dataRows.length - 1;

                  return Container(
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? Colors.transparent
                          : cs.onSurfaceVariant.withAlpha(51),
                      borderRadius: isLast
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )
                          : null,
                    ),
                    child: Row(
                      children: row.map((cell) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              cell,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: cs.onSurface.withAlpha(204),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
