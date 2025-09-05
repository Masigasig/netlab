import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/core/constants/app_colors.dart';

class SidebarItem extends StatelessWidget {
  final IconData? icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const SidebarItem({
    super.key,
    this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    return InkWell(
      onTap: (index == -1) ? null : () => onTap(index),
      borderRadius: BorderRadius.circular(8),
      hoverColor: (index == -1) ? Colors.transparent : Colors.white10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: icon != null
                  ? (isSelected
                        ? ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: AppColors.primaryGradient,
                            ).createShader(bounds),
                            child: Icon(icon, color: Colors.white, size: 24),
                          )
                        : Icon(icon, color: Colors.white, size: 24))
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),
            isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.primaryGradient,
                    ).createShader(bounds),
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      ),
    );
  }
}
