import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/vehicle_constants.dart';
import '../utils/vehicle_translations.dart';
import 'color_picker_field.dart';

/// Vehicle form fields (reusable for Add/Edit)
class VehicleFormFields extends StatelessWidget {
  // Car Make: dropdown with "Other" option
  final String? selectedCarMake;
  final Function(String?) onCarMakeChanged;
  final TextEditingController? otherCarMakeController; // Only used when "Other" is selected
  
  // Plate Number: text input
  final TextEditingController plateController;
  
  // Car Model: text input
  final TextEditingController typeController;
  
  // Color: color picker
  final Color? selectedColor;
  final Function(Color) onColorChanged;
  
  final bool enabled;

  const VehicleFormFields({
    super.key,
    required this.selectedCarMake,
    required this.onCarMakeChanged,
    this.otherCarMakeController,
    required this.plateController,
    required this.typeController,
    required this.selectedColor,
    required this.onColorChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    // Build car makes list with "Other" option
    final carMakesList = [
      ...VehicleConstants.carMakes,
      VehicleConstants.otherCarMake,
    ];

    final isOtherCarMakeSelected = selectedCarMake == VehicleConstants.otherCarMake;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Car Make Dropdown
        CustomDropdownField<String>(
          label: l10n.vehiclesFormNameLabel,
          selectedValue: selectedCarMake,
          items: carMakesList,
          getLabel: (item) => VehicleTranslations.getCarMakeTranslation(item, l10n),
          onChanged: enabled ? (value) => onCarMakeChanged(value) : (_) {},
          isRequired: true,
        ),
        // Show text field for "Other" car make
        if (isOtherCarMakeSelected && otherCarMakeController != null) ...[
          SizedBox(height: 16.h),
          CustomTextField(
            controller: otherCarMakeController!,
            enabled: enabled,
            label: l10n.vehiclesFormOtherCarMake,
            hintText: l10n.vehiclesFormOtherCarMake,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.vehiclesErrorValidation;
              }
              return null;
            },
            prefixIcon: Icon(EvaIcons.carOutline),
          ),
        ],
        SizedBox(height: 16.h),
        // Plate Number
        CustomTextField(
          controller: plateController,
          enabled: enabled,
          label: l10n.vehiclesFormPlateLabel,
          hintText: l10n.vehiclesFormPlateHint,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.vehiclesErrorValidation;
            }
            // Basic validation: at least 3 characters, alphanumeric
            final trimmedValue = value.trim();
            if (trimmedValue.length < 3) {
              return l10n.vehiclesPlateNumberMinLength;
            }
            // Allow alphanumeric and common plate number characters
            if (!RegExp(r'^[A-Za-z0-9\s\-]+$').hasMatch(trimmedValue)) {
              return l10n.vehiclesPlateNumberInvalid;
            }
            return null;
          },
          prefixIcon: Icon(EvaIcons.creditCardOutline),
        ),
        SizedBox(height: 16.h),
        // Car Model
        CustomTextField(
          controller: typeController,
          enabled: enabled,
          label: l10n.vehiclesFormTypeLabel,
          hintText: l10n.vehiclesFormTypeHint,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.vehiclesErrorValidation;
            }
            return null;
          },
          prefixIcon: Icon(EvaIcons.settingsOutline),
        ),
        SizedBox(height: 16.h),
        // Color Picker
        ColorPickerField(
          label: l10n.vehiclesFormColorLabel,
          selectedColor: selectedColor,
          onColorSelected: onColorChanged,
          enabled: enabled,
          validator: (color) {
            if (color == null) {
              return l10n.vehiclesErrorValidation;
            }
            return null;
          },
        ),
      ],
    );
  }
}


