import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/parking_validators.dart';
import 'location_picker_field.dart';

/// Reusable form fields for parking create/update
class ParkingFormFields extends StatelessWidget {
  final TextEditingController lotNameController;
  final TextEditingController addressController;
  final TextEditingController totalSpacesController;
  final TextEditingController hourlyRateController;
  final GeoPoint? selectedLocation;
  final VoidCallback onLocationPickerTap;
  final bool enabled;
  final bool showLocationFields;

  const ParkingFormFields({
    super.key,
    required this.lotNameController,
    required this.addressController,
    required this.totalSpacesController,
    required this.hourlyRateController,
    required this.selectedLocation,
    required this.onLocationPickerTap,
    this.enabled = true,
    this.showLocationFields = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: l10n.parkingLotNameLabel,
          hintText: l10n.parkingLotNameHint,
          controller: lotNameController,
          enabled: enabled,
          validator: (value) => ParkingValidators.lotName(value, l10n),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.parkingAddressLabel,
          hintText: l10n.parkingAddressHint,
          controller: addressController,
          enabled: enabled,
          validator: (value) => ParkingValidators.address(value, l10n),
        ),
        if (showLocationFields) ...[
          SizedBox(height: 16.h),
          LocationPickerField(
            selectedLocation: selectedLocation,
            onTap: onLocationPickerTap,
            enabled: enabled,
          ),
        ],
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.parkingTotalSpacesLabel,
          hintText: l10n.parkingTotalSpacesHint,
          controller: totalSpacesController,
          keyboardType: TextInputType.number,
          enabled: enabled,
          validator: (value) => ParkingValidators.totalSpaces(value, l10n),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.parkingHourlyRateLabel,
          hintText: l10n.parkingHourlyRateHint,
          controller: hourlyRateController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          enabled: enabled,
          validator: (value) => ParkingValidators.hourlyRate(value, l10n),
        ),
      ],
    );
  }
}

