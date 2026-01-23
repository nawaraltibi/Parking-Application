import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

/// Custom Text Field Widget
/// Consistent text input field with validation support
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hintText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool isPassword;
  final bool enabled;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.isPassword = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final actualObscureText = widget.isPassword ? _obscureText : false;
    final calculatedMaxLines = actualObscureText ? 1 : (widget.maxLines ?? 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.fieldLabel(context),
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 0.5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            enabled: widget.enabled,
            obscureText: actualObscureText,
            maxLines: calculatedMaxLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: widget.onChanged,
            style: AppTextStyles.fieldInput(context, enabled: widget.enabled),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.fieldHint(context),
              errorStyle: AppTextStyles.fieldError(context),
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.brightWhite
                  : AppColors.backgroundSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1.2,
                ),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? EvaIcons.eye
                            : EvaIcons.eyeOff,
                        color: AppColors.secondaryText,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

