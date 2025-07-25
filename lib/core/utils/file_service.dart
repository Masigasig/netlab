import 'dart:io' show File;
import 'dart:convert' show jsonEncode, jsonDecode, utf8;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class FileService {
  static Future<void>saveFile(Map<String,dynamic> data) async {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);

    if(kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..download = 'network.netlab'
        ..style.display = 'none';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } else {
      String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Network Simulation',
        fileName: 'network.netlab',
        type: FileType.custom,
        allowedExtensions: ['netlab'],
      );

      if (path != null) {
        if (!path.toLowerCase().endsWith('.netlab')) {
          path += '.netlab';
        }
        final file = File(path);
        await file.writeAsBytes(bytes);
      }
    }
  }

  static Future<Map<String, dynamic>?> loadFile() async {
    if(kIsWeb) {
      final input = html.FileUploadInputElement()..accept = '.netlab';
      input.click();

      try {
        await input.onChange.first;
        if (input.files?.isEmpty ?? true) return null;

        final file = input.files!.first;
        final reader = html.FileReader();
        reader.readAsText(file);

        await reader.onLoad.first;
        return jsonDecode(reader.result as String) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['netlab'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final jsonString = await File(path).readAsString();
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }

      return null;
    }
  }
}