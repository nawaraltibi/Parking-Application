import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/color_name_mapper.dart';
import '../utils/vehicle_constants.dart';
import '../utils/vehicle_translations.dart';

/// Color picker field widget
/// Shows a field with a color swatch that opens a color picker dialog
class ColorPickerField extends StatelessWidget {
  final String? label;
  final Color? selectedColor;
  final Function(Color) onColorSelected;
  final bool enabled;
  final String? Function(Color?)? validator;

  const ColorPickerField({
    super.key,
    this.label,
    this.selectedColor,
    required this.onColorSelected,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final colorName = selectedColor != null
        ? VehicleTranslations.getColorTranslation(
            ColorNameMapper.mapColorToName(selectedColor!),
            l10n,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.fieldLabel(context),
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: enabled ? () => _showColorPickerDialog(context) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.brightWhite
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: selectedColor != null && validator != null
                    ? (validator!(selectedColor) != null
                        ? AppColors.error
                        : AppColors.border.withValues(alpha: 0.3))
                    : AppColors.border.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Color swatch
                Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: selectedColor ?? AppColors.border,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: selectedColor != null
                        ? [
                            BoxShadow(
                              color: selectedColor!.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                ),
                SizedBox(width: 12.w),
                // Color name or hint
                Expanded(
                  child: Text(
                    colorName ?? l10n.vehiclesFormColorHint,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: colorName != null
                          ? (enabled
                              ? AppColors.primaryText
                              : AppColors.secondaryText)
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
                Icon(
                  EvaIcons.colorPaletteOutline,
                  color: enabled ? AppColors.primary : AppColors.secondaryText,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        if (selectedColor != null && validator != null && validator!(selectedColor) != null) ...[
          SizedBox(height: 4.h),
          Text(
            validator!(selectedColor)!,
            style: AppTextStyles.fieldError(context),
          ),
        ],
      ],
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    // Build list of colors from color names
    final availableColors = VehicleConstants.colors
        .map((colorName) => ColorNameMapper.mapNameToColor(colorName))
        .toList();

    Color pickerColor = selectedColor ?? availableColors.first;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.brightWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.vehiclesFormColorLabel,
                      style: AppTextStyles.titleLarge(context),
                    ),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
              contentPadding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        alignment: WrapAlignment.start,
                        children: availableColors.map((color) {
                        final isSelected = color.value == pickerColor.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              pickerColor = color;
                            });
                          },
                          child: Container(
                            width: 52.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border.withValues(alpha: 0.3),
                                width: isSelected ? 3.5 : 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: isSelected
                                ? Icon(
                                    EvaIcons.checkmark,
                                    color: _getContrastColor(color),
                                    size: 26.sp,
                                  )
                                : null,
                          ),
                        );
                        }).toList(),
                      ),
                      SizedBox(height: 14.h),
                      // Custom Color Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showCustomColorPicker(context, dialogContext, setState, pickerColor);
                          },
                          icon: Icon(EvaIcons.colorPaletteOutline, size: 18.sp),
                          label: Text(l10n.vehiclesColorPickerCustom),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 14.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.vehiclesColorPickerCancel,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onColorSelected(pickerColor);
                  },
                  child: Text(
                    l10n.vehiclesColorPickerConfirm,
                    style: AppTextStyles.labelLarge(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Get contrast color (black or white) based on background color brightness
  Color _getContrastColor(Color color) {
    final brightness = color.computeLuminance();
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  void _showCustomColorPicker(
    BuildContext context,
    BuildContext dialogContext,
    StateSetter setState,
    Color currentColor,
  ) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    // Initialize with a color that has proper saturation and lightness for slider to work
    // If currentColor is black or very dark, use a default color with good saturation
    Color customColor = currentColor;
    if (currentColor.computeLuminance() < 0.1) {
      // If color is very dark, initialize with a medium gray that has good saturation
      customColor = const Color(0xFF808080); // Medium gray
    }

    showDialog(
      context: dialogContext,
      builder: (customDialogContext) {
        return StatefulBuilder(
          builder: (customContext, customSetState) {
            return AlertDialog(
              backgroundColor: AppColors.brightWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
              title: Text(
                l10n.vehiclesColorPickerCustomTitle,
                style: AppTextStyles.titleLarge(context),
              ),
              titlePadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: customColor,
                  onColorChanged: (Color color) {
                    customSetState(() {
                      customColor = color;
                    });
                  },
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: false,
                  displayThumbColor: true,
                  paletteType: PaletteType.hslWithSaturation,
                  labelTypes: const [],
                  pickerAreaBorderRadius: BorderRadius.circular(16.r),
                  // Initialize picker with a color that allows horizontal slider to work
                  colorPickerWidth: 300,
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(customDialogContext).pop(),
                  child: Text(
                    l10n.vehiclesColorPickerCancel,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(customDialogContext).pop();
                    Navigator.of(dialogContext).pop();
                    onColorSelected(customColor);
                  },
                  child: Text(
                    l10n.vehiclesColorPickerConfirm,
                    style: AppTextStyles.labelLarge(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

