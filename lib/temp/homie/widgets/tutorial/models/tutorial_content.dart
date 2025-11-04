// import 'package:flutter/material.dart

// Main models
class TutorialSection {
  final String id;
  final String title;
  final String description;
  final dynamic icon;
  final bool isHugeIcon;
  final List<TutorialItem> items;

  TutorialSection({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isHugeIcon = false,
    required this.items,
  });
}

class TutorialImage {
  final String path;
  final String? caption;

  TutorialImage({required this.path, this.caption});

  factory TutorialImage.fromJson(Map<String, dynamic> json) {
    return TutorialImage(path: json['path'], caption: json['caption']);
  }
}

class TutorialItem {
  final String title;
  final String description;
  final dynamic icon;
  final bool isHugeIcon;
  final List<TutorialImage>? images;
  final String? imagePath;
  final List<ContentBlock> content;

  TutorialItem({
    required this.title,
    required this.description,
    required this.icon,
    this.isHugeIcon = false,
    this.images,
    this.imagePath,
    required this.content,
  });
}

// Content block types
enum ContentBlockType {
  text,
  image,
  numberedList,
  bulletList,
  note,
  warning,
  tip,
  definition,
  table,
  code,
}

class ContentBlock {
  final ContentBlockType type;
  final dynamic content;
  final String? title;
  final Map<String, dynamic>? metadata;

  ContentBlock({
    required this.type,
    required this.content,
    this.title,
    this.metadata,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: _parseContentType(json['type']),
      content: json['content'],
      title: json['title'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  static ContentBlockType _parseContentType(String type) {
    switch (type) {
      case 'text':
        return ContentBlockType.text;
      case 'image':
        return ContentBlockType.image;
      case 'numberedList':
        return ContentBlockType.numberedList;
      case 'bulletList':
        return ContentBlockType.bulletList;
      case 'note':
        return ContentBlockType.note;
      case 'warning':
        return ContentBlockType.warning;
      case 'tip':
        return ContentBlockType.tip;
      case 'definition':
        return ContentBlockType.definition;
      case 'table':
        return ContentBlockType.table;
      case 'code':
        return ContentBlockType.code;
      default:
        return ContentBlockType.text;
    }
  }
}

// Definition item
class DefinitionItem {
  final String term;
  final String definition;

  DefinitionItem({required this.term, required this.definition});

  factory DefinitionItem.fromJson(Map<String, dynamic> json) {
    return DefinitionItem(term: json['term'], definition: json['definition']);
  }
}
