import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';

/// Modern Bottom Navigation Bar Item
/// Represents a single item in the bottom navigation bar
class ModernNavItem {
  final IconData icon;
  final String label;
  final IconData? activeIcon;

  const ModernNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });
}

/// Modern Bottom Navigation Bar
/// A sleek, modern bottom navigation bar with bubble/pill active states,
/// smooth animations, and elegant design inspired by modern UI patterns.
///
/// Features:
/// - Bubble/pill-shaped active indicator with smooth animations
/// - Icon scale and color transitions
/// - Label visibility with fade animations
/// - Touch-friendly spacing and sizing
/// - Responsive design that adapts to screen sizes
/// - Uses app's design system colors and spacing
class ModernBottomNavBar extends StatelessWidget {
  /// List of navigation items
  final List<ModernNavItem> items;

  /// Currently selected index
  final int selectedIndex;

  /// Callback when an item is tapped
  final ValueChanged<int> onTap;

  /// Background color of the navigation bar
  final Color backgroundColor;

  /// Selected item color (icon and text)
  final Color selectedColor;

  /// Unselected item color (icon and text)
  final Color unselectedColor;

  /// Height of the navigation bar
  final double height;

  /// Whether to show labels (always visible or only when active)
  final bool showLabels;

  /// Border radius for the navigation bar
  final double borderRadius;

  /// Elevation/shadow for the navigation bar
  final double elevation;

  const ModernBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.backgroundColor = AppColors.surface,
    this.selectedColor = AppColors.primary,
    this.unselectedColor = AppColors.secondaryText,
    this.height = 58,
    this.showLabels = true,
    this.borderRadius = 0,
    this.elevation = 8,
  }) : assert(selectedIndex >= 0 && selectedIndex < items.length);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.zero,
      child: Container(
        constraints: BoxConstraints(
          minHeight: height.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: elevation * 1.5,
              offset: Offset(0, -3.h),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => _NavItem(
                item: items[index],
                isSelected: index == selectedIndex,
                onTap: () => onTap(index),
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                showLabel: showLabels,
                itemCount: items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual Navigation Item
/// Handles the animation and visual state of a single nav item
class _NavItem extends StatefulWidget {
  final ModernNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final int itemCount;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    required this.itemCount,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _colorAnimation = ColorTween(
      begin: widget.unselectedColor,
      end: widget.selectedColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate optimal width based on item count for better spacing
    final minItemWidth = widget.itemCount <= 2 ? 120.w : null;
    
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: minItemWidth != null 
            ? BoxConstraints(minWidth: minItemWidth)
            : null,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available height for this item - more compact
            final availableHeight = constraints.maxHeight;
            // Reserve space: icon area (28-32h), label (~9h), minimal padding
            final iconHeight = availableHeight > 0
                ? ((availableHeight - (widget.showLabel ? 13.h : 4.h)) * 0.8)
                    .clamp(28.h, 32.h).toDouble()
                : 30.h;
            final labelHeight = widget.showLabel ? 9.h : 0.0;
            final spacing = widget.showLabel ? 2.h : 0.0;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon with bubble background and scale animation
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SizedBox(
                      height: iconHeight,
                      width: 52.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Bubble background (pill-shaped) - compact and elegant
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            width: _bubbleAnimation.value * 52.w,
                            height: _bubbleAnimation.value * (iconHeight * 0.88),
                            decoration: BoxDecoration(
                              color: widget.isSelected
                                  ? widget.selectedColor.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: widget.isSelected
                                  ? [
                                      BoxShadow(
                                        color: widget.selectedColor.withValues(alpha: 0.2),
                                        blurRadius: 8.r,
                                        offset: Offset(0, 2.h),
                                        spreadRadius: 0,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          // Icon with scale animation
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Icon(
                              widget.isSelected && widget.item.activeIcon != null
                                  ? widget.item.activeIcon!
                                  : widget.item.icon,
                              color: _colorAnimation.value,
                              size: (iconHeight * 0.58).clamp(18.sp, 22.sp).toDouble(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Label with fade animation - adaptive spacing
                if (widget.showLabel)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: widget.isSelected ? 1.0 : 0.65,
                        child: Padding(
                          padding: EdgeInsets.only(top: spacing),
                          child: SizedBox(
                            height: labelHeight,
                            child: Text(
                              widget.item.label,
                              style: TextStyle(
                                color: _colorAnimation.value,
                                fontSize: 9.sp,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                letterSpacing: 0.15,
                                height: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

