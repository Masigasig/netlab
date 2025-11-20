part of 'sim_object_notifier.dart';

final wirelessConProvider =
    NotifierProvider.family<WirelessConNotifier, WirelessCon, String>(
      WirelessConNotifier.new,
    );

final wirelessConDeviceToIdMapProvider =
    NotifierProvider.family<
      WirelessConDeviceToIdMapNotifier,
      Map<String, String>,
      String
    >(WirelessConDeviceToIdMapNotifier.new);

final wirelessConMapProvider =
    NotifierProvider<WirelessConMapNotifier, Map<String, WirelessCon>>(
      WirelessConMapNotifier.new,
    );

final wirelessConWidgetsProvider =
    NotifierProvider<
      WirelessConWidgetsNotifier,
      Map<String, WirelessConWidget>
    >(WirelessConWidgetsNotifier.new);

class WirelessConNotifier extends SimObjectNotifier<WirelessCon> {
  final String arg;

  WirelessConNotifier(this.arg);

  @override
  WirelessCon build() {
    ref.onDispose(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(wirelessConDeviceToIdMapProvider(arg));
      });
    });
    return ref.read(wirelessConMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    // TODO: implement removeSelf
  }
}

class WirelessConDeviceToIdMapNotifier extends Notifier<Map<String, String>> {
  final String arg;
  WirelessConDeviceToIdMapNotifier(this.arg);

  @override
  Map<String, String> build() {
    return {};
  }
}

class WirelessConMapNotifier extends SimObjectMapNotifier<WirelessCon> {
  WirelessConMapNotifier()
    : super(
        mapProvider: wirelessConMapProvider,
        objectProvider: wirelessConProvider,
        widgetsProvider: wirelessConWidgetsProvider,
      );
}

class WirelessConWidgetsNotifier
    extends SimObjectWidgetsNotifier<WirelessConWidget> {}
