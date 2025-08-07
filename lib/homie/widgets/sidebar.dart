import 'package:flutter/material.dart';
import 'sidebar_item.dart';
import 'package:netlab/core/constants/app_image.dart';

class Sidebar extends StatefulWidget {
  final ValueChanged<int>? onItemSelected;

  const Sidebar({super.key, this.onItemSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool isExpanded = false;

  void toggleExpand() {
    setState(() => isExpanded = !isExpanded);
  }

  void onSelect(int index) {
    setState(() => selectedIndex = index);
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? 240 : 70,
      decoration: const BoxDecoration(color: Color.fromARGB(255, 26, 26, 32)),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                    child: Icon(Icons.science, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRect(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: isExpanded ? 1.0 : 0.0,
                          child: const Text(
                            'Netlab',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sidebar Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                SidebarItem(
                  lottiePath: AppLottie.homeIcon,
                  label: 'Home',
                  index: 0,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  lottiePath: AppLottie.playIcon,
                  label: 'Simulator',
                  index: 1,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  lottiePath: AppLottie.helpIcon,
                  label: 'Tutorials',
                  index: 2,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  lottiePath: AppLottie.bookIcon,
                  label: 'Study',
                  index: 3,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
              ],
            ),
          ),

          // Toggle Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    isExpanded ? Icons.chevron_left : Icons.chevron_right,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onPressed: toggleExpand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
