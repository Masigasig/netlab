import 'package:flutter/material.dart';
import '../models/content_block.dart';
import '../models/quiz_data.dart';
import '../../quiz/widgets/quiz_slider_widget.dart';
import '../../quiz/controllers/quiz_controller.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

// ignore_for_file: deprecated_member_use
class ContentRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;
  final String topicId;
  final String moduleId;
  final ModuleQuizController? quizController;

  const ContentRenderer({
    super.key,
    required this.blocks,
    required this.topicId,
    required this.moduleId,
    this.quizController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Collect all quiz data for the slider
    final quizDataList = blocks
        .where((block) => block.type == ContentBlockType.quiz)
        .map((block) => block.content as QuizData)
        .toList();

    // Filter out quiz blocks since they'll be rendered separately
    final nonQuizBlocks = blocks
        .where((block) => block.type != ContentBlockType.quiz)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render all non-quiz blocks
        ...nonQuizBlocks.map((block) => _renderBlock(context, block, cs)),
        // Render all quizzes as a single slider at the end
        if (quizDataList.isNotEmpty && quizController != null)
          QuizSliderWidget(
            quizDataList: quizDataList,
            quizController: quizController!,
          ),
      ],
    );
  }

  Widget _renderBlock(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
    switch (block.type) {
      case ContentBlockType.header:
        return _buildHeader(context, block, cs);
      case ContentBlockType.paragraph:
        return _buildParagraph(context, block, cs);
      case ContentBlockType.bulletList:
        return _buildBulletList(context, block, cs);
      case ContentBlockType.numberedList:
        return _buildNumberedList(context, block, cs);
      case ContentBlockType.definition:
        return _buildDefinitionList(context, block, cs);
      case ContentBlockType.note:
        return _buildNote(context, block, cs);
      case ContentBlockType.warning:
        return _buildWarning(context, block, cs);
      case ContentBlockType.code:
        return _buildCode(context, block, cs);
      case ContentBlockType.image:
        return _buildImage(context, block, cs);
      case ContentBlockType.table:
        return _buildTable(context, block, cs);
      case ContentBlockType.divider:
        return _buildDivider(context, block, cs);
      default:
        return const SizedBox.shrink();
    }
  }

  // BLOCK TYPES

  Widget _buildHeader(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          block.title,
          style: AppTextStyles.forSurface(AppTextStyles.headerMedium, context),
        ),
        if (block.content is String) ...[
          const SizedBox(height: 8),
          Text(
            block.content,
            style: AppTextStyles.forSecondary(
              AppTextStyles.subtitleLarge,
              context,
            ).copyWith(color: cs.onSurface.withOpacity(0.7)),
          ),
        ],
      ],
    );
  }

  Widget _buildParagraph(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        block.content,
        style: AppTextStyles.forSurface(
          AppTextStyles.bodyMedium,
          context,
        ).copyWith(height: 1.6, color: cs.onSurface.withOpacity(0.9)),
      ),
    );
  }

  Widget _buildBulletList(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
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
                      style: AppTextStyles.forSurface(
                        AppTextStyles.bodyMedium,
                        context,
                      ).copyWith(color: cs.onSurface.withOpacity(0.9)),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style:
                            AppTextStyles.forSurface(
                              AppTextStyles.bodyMedium,
                              context,
                            ).copyWith(
                              height: 1.6,
                              color: cs.onSurface.withOpacity(0.9),
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

  Widget _buildNumberedList(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
    final items = block.content as List<String>;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${entry.key + 1}.',
                    style: AppTextStyles.forSurface(
                      AppTextStyles.bodyLarge,
                      context,
                    ).copyWith(color: cs.onSurface.withOpacity(0.9)),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style:
                        AppTextStyles.forSurface(
                          AppTextStyles.bodyLarge,
                          context,
                        ).copyWith(
                          height: 1.6,
                          color: cs.onSurface.withOpacity(0.9),
                        ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCode(BuildContext context, ContentBlock block, ColorScheme cs) {
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
              style: AppTextStyles.forSecondary(
                AppTextStyles.subtitleMedium,
                context,
              ).copyWith(color: cs.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.content,
            style: AppTextStyles.forSurface(
              AppTextStyles.custom(fontSize: 14, fontWeight: FontWeight.w400),
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(BuildContext context, ContentBlock block, ColorScheme cs) {
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
              style: AppTextStyles.forSurface(
                AppTextStyles.bodyMedium,
                context,
              ).copyWith(height: 1.5, color: cs.onSurface.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
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
              style: AppTextStyles.forSurface(
                AppTextStyles.bodyLarge,
                context,
              ).copyWith(height: 1.6, color: cs.onSurface.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionList(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
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
                    Text(
                      def['term']!,
                      style: AppTextStyles.forSurface(
                        AppTextStyles.headerSmall,
                        context,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      def['definition']!,
                      style:
                          AppTextStyles.forSurface(
                            AppTextStyles.bodyMedium,
                            context,
                          ).copyWith(
                            height: 1.6,
                            color: cs.onSurface.withOpacity(0.9),
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

  Widget _buildImage(BuildContext context, ContentBlock block, ColorScheme cs) {
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
              style: AppTextStyles.forSecondary(AppTextStyles.caption, context)
                  .copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withOpacity(0.7),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, ContentBlock block, ColorScheme cs) {
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
        builder: (innerContext, constraints) {
          final table = DataTable(
            headingTextStyle: AppTextStyles.forSurface(
              AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              innerContext,
            ),
            dataTextStyle: AppTextStyles.forSurface(
              AppTextStyles.bodyMedium,
              innerContext,
            ).copyWith(color: cs.onSurface.withOpacity(0.9)),
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

  Widget _buildDivider(
    BuildContext context,
    ContentBlock block,
    ColorScheme cs,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(color: cs.outline.withOpacity(0.3), thickness: 1),
    );
  }
}
