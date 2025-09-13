import 'package:flutter/material.dart';
import 'sidebar_item.dart';
import 'package:netlab/temp/core/constants/app_colors.dart';
import 'package:hugeicons/hugeicons.dart';

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
        border: Border(right: BorderSide(color: AppColors.divider, width: 1.0)),
      ),
      child: Container(
        width: 70,
        decoration: const BoxDecoration(color: AppColors.background),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ).createShader(bounds),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedNanoTechnology,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 1,
              color: AppColors.divider.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  SidebarItem(
                    icon: Icons.home, //HugeIcons.strokeRoundedHome02,
                    label: 'Home',
                    index: 0,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    icon: Icons
                        .videogame_asset, //HugeIcons.strokeRoundedBlockGame,
                    label: 'Simulate',
                    index: 1,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    icon: Icons
                        .help_outline, //HugeIcons.strokeRoundedMessageQuestion,
                    label: 'Help',
                    index: 2,
                    selectedIndex: selectedIndex,
                    onTap: onSelect,
                  ),
                  SidebarItem(
                    icon: Icons.book, //HugeIcons.strokeRoundedBookEdit,
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
