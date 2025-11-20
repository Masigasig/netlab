part of 'sim_object_widget.dart';

class PhoneWidget extends DeviceWidget {
  const PhoneWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.phone);

  @override
  ConsumerState<PhoneWidget> createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends _DeviceWidgetState<PhoneWidget> {
  @override
  NotifierProviderFamily<PhoneNotifier, Phone, String> get provider =>
      phoneProvider;
}
