import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

/// Custom Elevated Button Widget
/// Button with gradient, loading state, and consistent styling
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final bool disabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;
  final bool useGradient;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 16,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = disabled || isLoading || onPressed == null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isButtonDisabled || !useGradient || backgroundColor != null
            ? null
            :  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.buttonGradient,
              ),
        borderRadius: BorderRadius.circular(borderRadius.r),
        color: isButtonDisabled
            ? (backgroundColor ?? AppColors.primary).withValues(alpha: 0.5)
            : backgroundColor,
        boxShadow: isButtonDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          padding: padding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          minimumSize: Size(0, 0),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  color: foregroundColor ?? AppColors.textOnPrimary,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                      style: AppTextStyles.buttonText(
                        context,
                        color: foregroundColor ?? AppColors.textOnPrimary,
                      ).copyWith(
                        fontSize: fontSize?.sp,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

