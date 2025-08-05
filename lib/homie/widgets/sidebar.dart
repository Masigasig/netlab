import 'package:flutter/material.dart';
import 'sidebar_item.dart';

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
      width: isExpanded ? 240 : 72,
      decoration: const BoxDecoration(color: Color(0xFF343541)),
      child: Column(
        children: [
          // Fixed Header with aligned icon
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
                    width: 24, // Match SidebarItem icon space
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

          const Divider(color: Colors.white24, height: 1),

          // Sidebar Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                SidebarItem(
                  icon: Icons.archive,
                  label: 'Archive',
                  index: 0,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  icon: Icons.image,
                  label: 'Images',
                  index: 1,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  icon: Icons.smart_toy,
                  label: 'Bot',
                  index: 2,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  icon: Icons.menu_book,
                  label: 'Docs',
                  index: 3,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
                SidebarItem(
                  icon: Icons.vpn_key,
                  label: 'Keys',
                  index: 4,
                  selectedIndex: selectedIndex,
                  isExpanded: isExpanded,
                  onTap: onSelect,
                ),
              ],
            ),
          ),

          // Toggle button
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
