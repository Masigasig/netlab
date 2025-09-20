import 'package:flutter/material.dart';
import 'models/content_block.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class ContentRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const ContentRenderer({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) => _renderBlock(context, block, cs)).toList(),
    );
  }

  Widget _renderBlock(BuildContext context, ContentBlock block, ColorScheme cs) {
    switch (block.type) {
      case ContentBlockType.header:
        return _buildHeader(block, cs);
      case ContentBlockType.paragraph:
        return _buildParagraph(block, cs);
      case ContentBlockType.bulletList:
        return _buildBulletList(block, cs);
      case ContentBlockType.numberedList:
        return _buildNumberedList(block, cs);
      case ContentBlockType.definition:
        return _buildDefinitionList(block, cs);
      case ContentBlockType.note:
        return _buildNote(block, cs);
      case ContentBlockType.warning:
        return _buildWarning(block, cs);
      case ContentBlockType.code:
        return _buildCode(block, cs);
      case ContentBlockType.image:
        return _buildImage(block, cs);
      case ContentBlockType.table:
        return _buildTable(block, cs);
      case ContentBlockType.divider:
        return _buildDivider(block, cs);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---- BLOCK TYPES ---- //

  Widget _buildHeader(ContentBlock block, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(block.title, style: AppTextStyles.headerMedium.copyWith(color: cs.onSurface)),
        if (block.content is String) ...[
          const SizedBox(height: 8),
          Text(
            block.content,
            style: AppTextStyles.subtitleLarge.copyWith(color: cs.onSurface.withOpacity(0.7)),
          ),
        ],
      ],
    );
  }

  Widget _buildParagraph(ContentBlock block, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        block.content,
        style: AppTextStyles.bodyMedium.copyWith(
          color: cs.onSurface.withOpacity(0.9),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBulletList(ContentBlock block, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (block.content as List<String>)
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurface.withOpacity(0.9))),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: cs.onSurface.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNumberedList(ContentBlock block, ColorScheme cs) {
    final items = block.content as List<String>;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map(
          (entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${entry.key + 1}.',
                      style: AppTextStyles.bodyLarge.copyWith(color: cs.onSurface.withOpacity(0.9)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: cs.onSurface.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildCode(ContentBlock block, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.title.isNotEmpty) ...[
            Text(
              block.title,
              style: AppTextStyles.subtitleMedium.copyWith(color: cs.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.content,
            style: AppTextStyles.custom(
              fontSize: 14,
              color: cs.onSurface,
              fontWeight: FontWeight.w400,
            ).copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(ContentBlock block, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.primary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              block.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: cs.onSurface.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(ContentBlock block, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.error.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: cs.error),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              block.content,
              style: AppTextStyles.bodyLarge.copyWith(
                color: cs.onSurface.withOpacity(0.9),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionList(ContentBlock block, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (block.content as List<Map<String, String>>)
            .map(
              (def) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(def['term']!, style: AppTextStyles.headerSmall.copyWith(color: cs.onSurface)),
                    const SizedBox(height: 4),
                    Text(
                      def['definition']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: cs.onSurface.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildImage(ContentBlock block, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(block.content, fit: BoxFit.cover),
          ),
          if (block.title.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              block.title,
              style: AppTextStyles.caption.copyWith(
                fontStyle: FontStyle.italic,
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(ContentBlock block, ColorScheme cs) {
    final headers = (block.additionalData?['headers'] as List<String>?) ?? [];
    final rows = block.content as List<List<String>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final table = DataTable(
            headingTextStyle: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
            dataTextStyle: AppTextStyles.bodyMedium.copyWith(
              color: cs.onSurface.withOpacity(0.9),
            ),
            columns: headers.map((header) => DataColumn(label: Text(header))).toList(),
            rows: rows
                .map(
                  (row) => DataRow(
                    cells: row.map((cell) => DataCell(Text(cell))).toList(),
                  ),
                )
                .toList(),
          );
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Center(child: table),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider(ContentBlock block, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(color: cs.outline.withOpacity(0.3), thickness: 1),
    );
  }
}
