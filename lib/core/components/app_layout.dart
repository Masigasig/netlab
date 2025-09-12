import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      width: 70,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            NavItem(
              icon: HugeIcons.strokeRoundedHome02,
              label: 'Home',
              isActive: currentLocation == '/home',
              onTap: () => context.go('/home'),
            ),
            NavItem(
              icon: HugeIcons.strokeRoundedSettings01,
              label: 'Settings',
              isActive: currentLocation == '/settings',
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  // bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // onEnter: (_) => setState(() => _isHovered = true),
      // onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isActive
                  ? Icon(
                      widget.icon,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Icon(widget.icon),

              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isActive
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
