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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Header item
                SidebarItem(
                  icon: Icons.science,
                  label: 'Netlab',
                  index: -1,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: (_) {},
                ),
                const SizedBox(height: 16),

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

          SidebarItem(
            icon: isExpanded ? Icons.chevron_left : Icons.chevron_right,
            label: '',
            index: -2,
            selectedIndex: selectedIndex,
            isExpanded: isExpanded,
            onTap: (_) => toggleExpand(),
            isToggleButton: true,
          ),
        ],
      ),
    );
  }
}