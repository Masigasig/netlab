import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

class SetttingsPopup extends ConsumerStatefulWidget {
  const SetttingsPopup({super.key});

  @override
  ConsumerState<SetttingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends ConsumerState<SetttingsPopup> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Settings Popup Rebuit');
    final currentMsgSpeed = ref.read(simScreenProvider).messageSpeed;
    final currentArpReqTimeout = ref.read(simScreenProvider).arpReqTimeout;

    double tempMsgSpeed = currentMsgSpeed;
    double tempArpReqTimeout = currentArpReqTimeout;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text('Message travel speed : ${tempMsgSpeed.toInt()}'),
                    ],
                  ),
                  Slider(
                    value: tempMsgSpeed,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (value) => setState(() {
                      tempMsgSpeed = value;
                    }),
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text('ARP Req Timeout: ${tempArpReqTimeout.toInt()}s'),
                    ],
                  ),
                  Slider(
                    value: tempArpReqTimeout,
                    min: 10,
                    max: 120,
                    divisions: 110,
                    onChanged: (value) => setState(() {
                      tempArpReqTimeout = value;
                    }),
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(simScreenProvider.notifier)
                              .setMessageSpeed(tempMsgSpeed);
                          ref
                              .read(simScreenProvider.notifier)
                              .setArpReqTimeout(tempArpReqTimeout);
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
