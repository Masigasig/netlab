part of 'sim_object_widget.dart';

class WirelessHostWidget extends DeviceWidget {
  const WirelessHostWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.wirelessHost);

  @override
  ConsumerState<WirelessHostWidget> createState() => _WirelessHostWidgetState();
}

class _WirelessHostWidgetState extends _DeviceWidgetState<WirelessHostWidget> {
  @override
  NotifierProviderFamily<WirelessHostNotifier, WirelessHost, String>
  get provider => wirelessHostProvider;

  @override
  Widget _deviceWithLabel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: DeviceWidget.size,
          height: DeviceWidget.size,
          child: Image.asset(widget.imagePath, fit: BoxFit.contain),
        ),
        Material(
          color: Colors.transparent,
          child: Consumer(
            builder: (context, ref, child) {
              final name = ref.watch(
                provider(widget.simObjectId).select((s) => s.name),
              );

              final ipAddress = ref.watch(
                provider(widget.simObjectId).select((w) => w.ipAddress),
              );

              final selectedIdOnInfo = ref.watch(
                simScreenProvider.select((s) => s.selectedDeviceOnInfo),
              );

              final isSelected = widget.simObjectId == selectedIdOnInfo;

              return SizedBox(
                width: DeviceWidget.size,
                child: Column(
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      ipAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
