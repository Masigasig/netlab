import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/constants/app_image.dart';

part 'connection_widget.dart';
part 'device_widget.dart';
part 'host_widget.dart';
part 'message_widget.dart';
part 'router_widget.dart';
part 'switch_widget.dart';

abstract class SimObjectWidget extends ConsumerStatefulWidget {
  final String simObjectId;

  const SimObjectWidget({super.key, required this.simObjectId});
}

abstract class _SimObjectWidgetState<T extends SimObjectWidget>
    extends ConsumerState<T> {}
