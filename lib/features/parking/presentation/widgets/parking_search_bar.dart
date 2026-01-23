import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Search bar with debouncing for parking list
class ParkingSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ParkingSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  State<ParkingSearchBar> createState() => _ParkingSearchBarState();
}

class _ParkingSearchBarState extends State<ParkingSearchBar>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _borderColorAnimation = ColorTween(
      begin: AppColors.border,
      end: AppColors.primary,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onSearchChanged() {
    setState(() {}); // Rebuild to show/hide clear button
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(_controller.text);
    });
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final searchHint = l10n.parkingStatusActive == 'Active'
        ? 'Search for parking...'
        : 'ابحث عن موقف...';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: _borderColorAnimation.value ?? AppColors.border,
                  width: _focusNode.hasFocus ? 1.5 : 1.0,
                ),
                boxShadow: _focusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: AppTextStyles.fieldInput(context),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: AppTextStyles.fieldHint(context),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(
                      EvaIcons.search,
                      color: _focusNode.hasFocus
                          ? AppColors.primary
                          : AppColors.secondaryText,
                      size: 22.sp,
                    ),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                _controller.clear();
                                widget.onChanged('');
                                setState(() {});
                              },
                              child: Icon(
                                EvaIcons.closeCircle,
                                color: AppColors.secondaryText,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

