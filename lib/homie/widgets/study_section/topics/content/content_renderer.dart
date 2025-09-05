import 'package:flutter/material.dart';
import 'models/content_block.dart';
import 'package:netlab/core/constants/app_text.dart';

class ContentRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const ContentRenderer({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) => _renderBlock(block)).toList(),
    );
  }

  Widget _renderBlock(ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.header:
        return _buildHeader(block);
      case ContentBlockType.paragraph:
        return _buildParagraph(block);
      case ContentBlockType.bulletList:
        return _buildBulletList(block);
      case ContentBlockType.numberedList:
        return _buildNumberedList(block);
      case ContentBlockType.definition:
        return _buildDefinitionList(block);
      case ContentBlockType.note:
        return _buildNote(block);
      case ContentBlockType.warning:
        return _buildWarning(block);
      case ContentBlockType.code:
        return _buildCode(block);
      case ContentBlockType.image:
        return _buildImage(block);
      case ContentBlockType.table:
        return _buildTable(block);
      case ContentBlockType.divider:
        return _buildDivider(block);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader(ContentBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          block.title,
          style: AppTextStyles.headerMedium, // Using your header style
        ),
        if (block.content is String) ...[
          const SizedBox(height: 8),
          Text(
            block.content,
            style: AppTextStyles.withColor(
              AppTextStyles.subtitleLarge,
              Colors.white.withValues(alpha: 0.7),
            ), // Using subtitle style with white color
          ),
        ],
        // const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildParagraph(ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        block.content,
        style: AppTextStyles.withColor(
          AppTextStyles.bodyMedium,
          Colors.white.withValues(alpha: 0.9),
        ), // Using body style with custom color
      ),
    );
  }

  Widget _buildBulletList(ContentBlock block) {
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
                    Text(
                      '• ',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium.copyWith(height: 1.6),
                          Colors.white.withValues(alpha: 0.9),
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

  Widget _buildNumberedList(ContentBlock block) {
    final items = block.content as List<String>;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${entry.key + 1}.',
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyLarge,
                          Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyLarge.copyWith(height: 1.6),
                          Colors.white.withValues(alpha: 0.9),
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

  Widget _buildCode(ContentBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.title.isNotEmpty) ...[
            Text(
              block.title,
              style: AppTextStyles.withColor(
                AppTextStyles.subtitleMedium,
                Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.content,
            style: AppTextStyles.custom(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ).copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(ContentBlock block) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.blue.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              block.content,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyMedium.copyWith(height: 1.5),
                Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(ContentBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              block.content,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyLarge.copyWith(height: 1.6),
                Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionList(ContentBlock block) {
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
                    Text(def['term']!, style: AppTextStyles.headerSmall),
                    const SizedBox(height: 4),
                    Text(
                      def['definition']!,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium.copyWith(height: 1.6),
                        Colors.white.withValues(alpha: 0.9),
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

  Widget _buildImage(ContentBlock block) {
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
              style: AppTextStyles.withColor(
                AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(ContentBlock block) {
    final headers = (block.additionalData?['headers'] as List<String>?) ?? [];
    final rows = block.content as List<List<String>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final table = DataTable(
            headingTextStyle: AppTextStyles.withColor(
              AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              Colors.white,
            ),
            dataTextStyle: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              Colors.white.withValues(alpha: 0.9),
            ),
            columns: headers
                .map((header) => DataColumn(label: Text(header)))
                .toList(),
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

  Widget _buildDivider(ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
    );
  }
}
