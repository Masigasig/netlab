import 'package:flutter/material.dart';
import 'sidebar_item.dart';
import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/constants/app_colors.dart';

class Sidebar extends StatefulWidget {
  final ValueChanged<int>? onItemSelected;

  const Sidebar({super.key, this.onItemSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  void onSelect(int index) {
    setState(() => selectedIndex = index);
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColors.divider,
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        width: 70,
        decoration: const BoxDecoration(color: AppColors.background),
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
                    onTap: (_) {},
                  ),
                  const SizedBox(height: 16),

                  SidebarItem(
                    lottiePath: AppLottie.homeIcon,
                    label: 'Home',
                    index: 0,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    lottiePath: AppLottie.playIcon,
                    label: 'Simulator',
                    index: 1,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    lottiePath: AppLottie.helpIcon,
                    label: 'Tutorials',
                    index: 2,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    lottiePath: AppLottie.bookIcon,
                    label: 'Study',
                    index: 3,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}