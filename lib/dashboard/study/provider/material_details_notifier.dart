import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialDetailProvider =
    NotifierProvider<MaterialDetailNotifier, Map<String, dynamic>>(
      MaterialDetailNotifier.new,
    );

class MaterialDetailNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setContent(Map<String, dynamic> json) {
    state = json;
  }
}
