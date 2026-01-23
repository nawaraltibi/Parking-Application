import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';

/// Reusable location picker field widget
class LocationPickerField extends StatelessWidget {
  final GeoPoint? selectedLocation;
  final VoidCallback onTap;
  final bool enabled;

  const LocationPickerField({
    super.key,
    required this.selectedLocation,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.parkingSelectLocationLabel,
          style: AppTextStyles.fieldLabel(context),
        ),
        SizedBox(height: 8.h),
        CustomElevatedButton(
          title: l10n.parkingChooseLocationButton,
          onPressed: enabled ? onTap : null,
          useGradient: false,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          icon: Icon(
            EvaIcons.map,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
        if (selectedLocation != null) ...[
          SizedBox(height: 16.h),
          LocationDisplayField(
            label: l10n.parkingLatitudeLabel,
            value: selectedLocation!.latitude,
          ),
          SizedBox(height: 16.h),
          LocationDisplayField(
            label: l10n.parkingLongitudeLabel,
            value: selectedLocation!.longitude,
          ),
        ],
      ],
    );
  }
}

/// Read-only location display field
class LocationDisplayField extends StatelessWidget {
  final String label;
  final double value;

  const LocationDisplayField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hintText: value.toStringAsFixed(6),
      controller: TextEditingController(
        text: value.toStringAsFixed(6),
      )..selection = TextSelection.fromPosition(
          const TextPosition(offset: 0),
        ),
      enabled: false,
    );
  }
}

