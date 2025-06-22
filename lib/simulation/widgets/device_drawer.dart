import 'package:flutter/material.dart';

import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/model/spawner.dart';

class DeviceDrawer extends StatefulWidget {
  final double width = AppConstants.deviceDrawerWidth;

  const DeviceDrawer({super.key});

  @override
  State<DeviceDrawer> createState() => _DeviceDrawerState();
}

class _DeviceDrawerState extends State<DeviceDrawer> {
  bool _isOpen = true;

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: AppConstants.animationSpeed),
          top: 0,
          bottom: 0,
          left: _isOpen ? 0 : -widget.width,
          width: widget.width,
          child: Material(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Devices",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Divider(color: Colors.white),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: Spawner.allSpawners.length,
                    itemBuilder: (context, index) => Spawner.allSpawners[index],
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: AppConstants.animationSpeed),
          top: 47,
          left: _isOpen ? widget.width : 0,
          child: GestureDetector(
            onTap: () => _toggleDrawer(),
            child: Container(
              width: 20,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Icon(
                _isOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
