import 'package:flutter/material.dart';
import 'models/content_block.dart';

class ContentRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const ContentRenderer({
    super.key,
    required this.blocks,
  });

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
        const SizedBox(height: 24),
        Text(
          block.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (block.content is String) ...[
          const SizedBox(height: 8),
          Text(
            block.content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildParagraph(ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        block.content,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBulletList(ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (block.content as List<String>).map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', 
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildNumberedList(ContentBlock block) {
    final items = block.content as List<String>;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '${entry.key + 1}.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCode(ContentBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.title.isNotEmpty) ...[
            Text(
              block.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(ContentBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.withOpacity(0.9)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              block.content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                height: 1.6,
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
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.withOpacity(0.9)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              block.content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                height: 1.6,
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
        children: (block.content as List<Map<String, String>>).map((def) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def['term']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  def['definition']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
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
            child: Image.asset(
              block.content,
              fit: BoxFit.cover,
            ),
          ),
          if (block.title.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              block.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
          columns: headers.map((header) => DataColumn(label: Text(header))).toList(),
          rows: rows.map((row) => 
            DataRow(
              cells: row.map((cell) => DataCell(Text(cell))).toList(),
            ),
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildDivider(ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(
        height: 1,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}
