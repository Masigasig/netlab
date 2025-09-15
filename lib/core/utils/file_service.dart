import 'dart:io' show File, Platform;
import 'dart:convert' show jsonEncode, jsonDecode, utf8;
import 'dart:typed_data' show Uint8List;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class FileService {
  static const _extension = 'json';
  static const _filename = 'network';

  static Future<void> saveFile(Map<String, dynamic> data) async {
    final bytes = utf8.encode(jsonEncode(data));

    if (kIsWeb) {
      await _saveFileWeb(bytes);
    } else if (Platform.isWindows) {
      await _saveFileWindows(bytes);
    } else if (Platform.isAndroid) {
      await _saveFileAndroid(bytes);
    }
  }

  static Future<Map<String, dynamic>?> loadFile() async {
    if (kIsWeb) {
      return await _loadFileWeb();
    } else if (Platform.isWindows) {
      return await _loadFileAndroidAndWindows();
    } else if (Platform.isAndroid) {
      return await _loadFileAndroidAndWindows();
    }

    return null;
  }

  static Future<void> _saveFileAndroid(Uint8List bytes) async {
    await FilePicker.platform.saveFile(
      dialogTitle: 'Save Network Simulation',
      fileName: '$_filename.$_extension',
      type: FileType.custom,
      allowedExtensions: [_extension],
      bytes: bytes,
    );
  }

  static Future<Map<String, dynamic>?> _loadFileAndroidAndWindows() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [_extension],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final jsonString = await File(path).readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }

    return null;
  }

  static Future<void> _saveFileWindows(Uint8List bytes) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Network Simulation',
      fileName: '$_filename.$_extension',
      type: FileType.custom,
      allowedExtensions: [_extension],
      bytes: bytes,
    );

    if (path != null && !path.endsWith('.$_extension')) {
      final correctedPath = '$path.$_extension';
      final file = File(correctedPath);
      await file.writeAsBytes(bytes);
    }
  }

  static Future<void> _saveFileWeb(Uint8List bytes) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = '$_filename.$_extension'
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }

  static Future<Map<String, dynamic>?> _loadFileWeb() async {
    final input = html.FileUploadInputElement()..accept = '.$_extension';
    input.click();

    try {
      await input.onChange.first;
      if (input.files?.isEmpty ?? true) return null;

      final reader = html.FileReader();
      reader.readAsText(input.files!.first);
      await reader.onLoad.first;

      return jsonDecode(reader.result as String) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
