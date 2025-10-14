import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/routing/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    debugPrint('AppLayout Widget rebuilt');
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
    debugPrint('SideBar Widget rebuilt');
    final String currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      width: 55,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NavItem(
            icon: HugeIcons.strokeRoundedDashboardSquare03,
            isActive: currentLocation == Routes.dashboard,
            onTap: () => context.go(Routes.dashboard),
          ),
          const SizedBox(height: 16),
          NavItem(
            icon: HugeIcons.strokeRoundedCalculator01,
            isActive: currentLocation == Routes.tools,
            onTap: () => context.go(Routes.tools),
          ),
          const SizedBox(height: 16),
          NavItem(
            icon: HugeIcons.strokeRounded3DView,
            isActive: currentLocation == Routes.home,
            onTap: () => context.go(Routes.home),
          ),
          const SizedBox(height: 16),
          NavItem(
            icon: HugeIcons.strokeRoundedBookOpen02,
            isActive: currentLocation == Routes.study,
            onTap: () => context.go(Routes.study),
          ),
          const SizedBox(height: 16),
          NavItem(
            icon: HugeIcons.strokeRoundedSettings01,
            isActive: currentLocation == Routes.settings,
            onTap: () => context.go(Routes.settings),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final List<List<dynamic>> icon;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('NavItem Widget rebuilt:');

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color iconColor = widget.isActive
        ? colorScheme.secondary
        : _isHovered
        ? colorScheme.secondary
        : colorScheme.onSurface;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [HugeIcon(icon: widget.icon, color: iconColor)],
          ),
        ),
      ),
    );
  }
}
