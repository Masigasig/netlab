enum ContentBlockType {
  header,
  paragraph,
  bulletList,
  numberedList,
  definition,
  note,
  warning,
  image,
  code,
  table,
  diagram,
  quiz,
  video,
  codeOutput,
  divider
}

class ContentBlock {
  final ContentBlockType type;
  final String title;
  final dynamic content;
  final Map<String, dynamic>? additionalData;

  ContentBlock({
    required this.type,
    this.title = '',
    required this.content,
    this.additionalData,
  });
}

abstract class ModuleContent {
  String get moduleId;
  List<ContentBlock> getContent();
}