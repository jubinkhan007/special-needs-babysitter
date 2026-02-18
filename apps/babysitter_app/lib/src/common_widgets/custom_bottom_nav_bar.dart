import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Custom bottom navigation bar item data
class CustomNavItem {
  final String label;
  final String? svgAssetPath;
  final String? pngAssetPath;

  const CustomNavItem({
    required this.label,
    this.svgAssetPath,
    this.pngAssetPath,
  });
}

/// Custom bottom navigation bar matching the Figma design
/// - Active item has a pill-shaped cyan background
/// - Inactive items are dark gray
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomNavItem> items;

  // Design tokens
  static const Color _selectedColor = Color(0xFF5EB9D3);
  static const Color _unselectedColor = Color(0xFF6B7280);
  static const Color _pillColor = Color(0xFFE8F6FA);

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE7F5FC),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return _NavItem(
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final CustomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _selectedColor = Color(0xFF5EB9D3);
  static const Color _unselectedColor = Color(0xFF6B7280);

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _selectedColor : _unselectedColor;

    Widget iconWidget;
    if (item.svgAssetPath != null) {
      iconWidget = SvgPicture.asset(
        item.svgAssetPath!,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else if (item.pngAssetPath != null) {
      iconWidget = Image.asset(
        item.pngAssetPath!,
        width: 22,
        height: 22,
        color: color,
      );
    } else {
      iconWidget = Icon(Icons.circle, size: 22, color: color);
    }

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
