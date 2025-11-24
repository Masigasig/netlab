import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/tutorial_content.dart';

class TutorialJsonService {
  static final _iconMap = <String, ({dynamic icon, bool isHuge})>{
    // Section icons
    'lightbulb_outline': (icon: HugeIcons.strokeRoundedQuiz05, isHuge: true),
    'construction': (icon: HugeIcons.strokeRoundedBookOpen02, isHuge: true),
    'control_camera': (icon: HugeIcons.strokeRoundedPlay, isHuge: true),
    'list_alt': (icon: HugeIcons.strokeRoundedQuiz03, isHuge: true),
    'info': (icon: HugeIcons.strokeRoundedSearch02, isHuge: true),

    // Control icons
    'arrow_back': (icon: HugeIcons.strokeRoundedArrowLeft02, isHuge: true),
    'save': (icon: HugeIcons.strokeRoundedFileDownload, isHuge: true),
    'folder_open': (icon: HugeIcons.strokeRoundedFileUpload, isHuge: true),
    'add_circle': (icon: HugeIcons.strokeRoundedAdd01, isHuge: true),
    'add_device_close': (
      icon: HugeIcons.strokeRoundedMultiplicationSign,
      isHuge: true,
    ),
    'settings': (icon: HugeIcons.strokeRoundedSettings05, isHuge: true),
    'article': (icon: HugeIcons.strokeRoundedComputerTerminal01, isHuge: true),
    'terminal': (icon: HugeIcons.strokeRoundedComputerTerminal01, isHuge: true),
    'terminal_close': (
      icon: HugeIcons.strokeRoundedMultiplicationSign,
      isHuge: true,
    ),
    'play_arrow': (icon: HugeIcons.strokeRoundedPlay, isHuge: true),
    'center_focus_strong': (
      icon: HugeIcons.strokeRoundedKeyframeAlignCenter,
      isHuge: true,
    ),
    'restart_alt': (icon: HugeIcons.strokeRoundedClean, isHuge: true),

    // Device icons
    'devices': (icon: HugeIcons.strokeRoundedTabletConnectedUsb, isHuge: true),
    'computer': (icon: HugeIcons.strokeRoundedComputer, isHuge: true),
    'router': (icon: HugeIcons.strokeRoundedRoad02, isHuge: true),
    'wifi_tethering': (icon: HugeIcons.strokeRoundedRouter, isHuge: true),
    'mail': (icon: HugeIcons.strokeRoundedMail01, isHuge: true),

    // getting started
    'cable_outlined': (icon: HugeIcons.strokeRoundedFullScreen, isHuge: true),
  };

  static Future<List<TutorialSection>> loadTutorials() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/tutorial_material/tutorial_data_new.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> sections = jsonData['sections'];

      return sections.map(_parseSection).toList();
    } catch (e) {
      throw Exception('Failed to load tutorials: $e');
    }
  }

  static TutorialSection _parseSection(dynamic json) {
    final Map<String, dynamic> data = json;
    final iconInfo =
        _iconMap[data['icon']] ?? (icon: Icons.help_outline, isHuge: false);

    return TutorialSection(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      icon: iconInfo.icon,
      isHugeIcon: iconInfo.isHuge,
      items: (data['items'] as List).map(_parseItem).toList(),
    );
  }

  static TutorialItem _parseItem(dynamic json) {
    final Map<String, dynamic> data = json;
    final iconInfo =
        _iconMap[data['icon']] ?? (icon: Icons.help_outline, isHuge: false);

    return TutorialItem(
      title: data['title'],
      description: data['description'],
      icon: iconInfo.icon,
      isHugeIcon: iconInfo.isHuge,
      imagePath: data['imagePath'],
      images: data['images'] != null
          ? (data['images'] as List)
                .map((img) => TutorialImage.fromJson(img))
                .toList()
          : null,
      content: (data['content'] as List)
          .map((c) => ContentBlock.fromJson(c))
          .toList(),
    );
  }
}
