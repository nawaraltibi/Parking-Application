import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';

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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: Offset(0, -4.h),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: Offset(0, -2.h),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => Expanded(
                child: _NavItem(
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
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _colorAnimation = ColorTween(
      begin: widget.unselectedColor,
      end: widget.selectedColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
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
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: widget.selectedColor.withValues(alpha: 0.1),
          highlightColor: widget.selectedColor.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available height for this item - more compact
            final availableHeight = constraints.maxHeight;
            // Reserve space: icon area (28-32h), label (14h for Arabic text), minimal padding
            final iconHeight = availableHeight > 0
                ? ((availableHeight - (widget.showLabel ? 18.h : 4.h)) * 0.75)
                    .clamp(28.h, 32.h).toDouble()
                : 30.h;
            final spacing = widget.showLabel ? 4.h : 0.0;
            
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
                          // Bubble background (pill-shaped) with smooth gradient - elegant and refined
                          AnimatedBuilder(
                            animation: _bubbleAnimation,
                            builder: (context, child) {
                              return Container(
                                width: _bubbleAnimation.value * 56.w,
                                height: _bubbleAnimation.value * (iconHeight * 0.95),
                                decoration: BoxDecoration(
                                  gradient: widget.isSelected
                                      ? LinearGradient(
                                          colors: [
                                            widget.selectedColor.withValues(alpha: 0.18),
                                            widget.selectedColor.withValues(alpha: 0.10),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: widget.isSelected
                                      ? null
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: widget.isSelected
                                      ? [
                                          BoxShadow(
                                            color: widget.selectedColor.withValues(alpha: 0.12),
                                            blurRadius: 10.r,
                                            offset: Offset(0, 2.h),
                                            spreadRadius: 0,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            },
                          ),
                          // Icon with scale animation and smooth transition
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Icon(
                                  widget.isSelected && widget.item.activeIcon != null
                                      ? widget.item.activeIcon!
                                      : widget.item.icon,
                                  color: _colorAnimation.value,
                                  size: (iconHeight * 0.6).clamp(20.sp, 24.sp).toDouble(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Label with fade animation and smooth transition
                if (widget.showLabel)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return AnimatedOpacity(
                        opacity: widget.isSelected ? 1.0 : 0.6,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.only(top: spacing),
                          child: Text(
                            widget.item.label,
                            style: AppTextStyles.labelSmall(
                              context,
                              color: _colorAnimation.value,
                            ).copyWith(fontSize: 9.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            softWrap: false,
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
        ),
      ),
    );
  }
}

