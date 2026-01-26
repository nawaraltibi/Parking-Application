import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/assets/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../utils/color_name_mapper.dart';
import '../utils/vehicle_translations.dart';
import 'delete_vehicle_dialog.dart';

/// Vehicle Card Widget (Reusable)
/// Designed to match Parking cards style and Material 3 aesthetics.
class VehicleCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.vehicle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final vehicleColor = ColorNameMapper.mapNameToColor(vehicle.color);

    // Check if color is black specifically
    final isBlack = vehicle.color.toLowerCase() == 'black';

    // Adjust opacity based on color brightness (darker or brighter colors need less opacity)
    final luminance = vehicleColor.computeLuminance();
    final isDarkOrBright =
        luminance < 0.15 || luminance > 0.85; // Very dark or very bright

    // Special handling for black color - much softer
    final adjustedOpacity = isBlack
        ? 0.004
        : (isDarkOrBright
              ? 0.008
              : 0.015); // Less opacity for dark/bright colors
    final borderOpacity = isBlack ? 0.03 : (isDarkOrBright ? 0.05 : 0.08);
    final shadowOpacity = isBlack ? 0.02 : (isDarkOrBright ? 0.03 : 0.06);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: Container(
        decoration: BoxDecoration(
          // Subtle gradient background with vehicle color
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              vehicleColor.withValues(alpha: adjustedOpacity),
              AppColors.surface,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: vehicleColor.withValues(alpha: borderOpacity),
            width: 1,
          ),
          boxShadow: [
            // Colored shadow with vehicle color
            BoxShadow(
              color: vehicleColor.withValues(alpha: shadowOpacity),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            // Standard shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Enhanced vertical bar with vehicle color and gradient
            Container(
              width: 6.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [vehicleColor, vehicleColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  bottomLeft: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: vehicleColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(2, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            // Main card content
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  splashColor: vehicleColor.withValues(alpha: 0.06),
                  highlightColor: vehicleColor.withValues(alpha: 0.03),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Logo, Title and Actions
                        Row(
                          children: [
                            // Manufacturer Logo
                            _ManufacturerLogo(carMake: vehicle.carMake),
                            SizedBox(width: 12.w),
                            // Vehicle Name (translated)
                            Expanded(
                              child: Text(
                                '${VehicleTranslations.getCarMakeTranslation(vehicle.carMake, l10n)} ${vehicle.carModel}',
                                style: AppTextStyles.cardTitle(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _StatusIcon(vehicle: vehicle),
                            SizedBox(width: 8.w),
                            _ActionsMenu(vehicle: vehicle),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Vehicle Details
                        Row(
                          children: [
                            Expanded(
                              child: _InfoRow(
                                icon: EvaIcons.creditCardOutline,
                                label: l10n.vehiclesFormPlateLabel,
                                value: vehicle.platNumber,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _InfoRow(
                                icon: EvaIcons.settingsOutline,
                                label: l10n.vehiclesFormTypeLabel,
                                value: vehicle.carModel,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _ColorInfoRow(
                          icon: EvaIcons.colorPaletteOutline,
                          label: l10n.vehiclesFormColorLabel,
                          colorName: vehicle.color,
                          l10n: l10n,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  final VehicleEntity vehicle;
  const _ActionsMenu({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return PopupMenuButton<_VehicleMenuAction>(
      icon: Icon(
        EvaIcons.moreVertical,
        color: AppColors.secondaryText,
        size: 20.sp,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 8,
      color: AppColors.brightWhite,
      itemBuilder: (context) => [
        PopupMenuItem<_VehicleMenuAction>(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          value: _VehicleMenuAction.edit,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(EvaIcons.edit, size: 18.sp, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  l10n.vehiclesActionEdit,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Future.delayed(Duration.zero, () {
            context.push('/vehicles/edit', extra: vehicle);
          }),
        ),
        PopupMenuItem<_VehicleMenuAction>(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          value: _VehicleMenuAction.delete,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.error.withValues(alpha: 0.08),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  EvaIcons.trash2Outline,
                  size: 18.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 8.w),
                Text(
                  l10n.vehiclesActionDelete,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Future.delayed(Duration.zero, () {
            DeleteVehicleDialog.show(
              context,
              vehicleId: vehicle.vehicleId,
              plateNumber: vehicle.platNumber,
            );
          }),
        ),
      ],
    );
  }
}

enum _VehicleMenuAction { edit, delete }

/// Widget to display status icon instead of text badge
class _StatusIcon extends StatelessWidget {
  final VehicleEntity vehicle;

  const _StatusIcon({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    // Modification request states take precedence
    if (vehicle.isModificationRejected) {
      icon = EvaIcons.closeCircle;
      iconColor = AppColors.error;
    } else if (vehicle.isModificationPending) {
      icon = EvaIcons.clockOutline;
      iconColor = AppColors.warning;
    } else if (vehicle.isInactive) {
      icon = EvaIcons.alertCircle;
      iconColor = AppColors.secondaryText;
    } else {
      // Active status
      icon = EvaIcons.checkmarkCircle2;
      iconColor = AppColors.success;
    }

    return Icon(icon, size: 22.sp, color: iconColor);
  }
}

/// Widget to display manufacturer logo based on car make
/// Shows the appropriate logo for each vehicle based on its car make
class _ManufacturerLogo extends StatelessWidget {
  final String carMake;

  const _ManufacturerLogo({required this.carMake});

  @override
  Widget build(BuildContext context) {
    // Get the logo path based on car make
    final logoPath = Assets.getCarLogoPath(carMake);

    // Debug: Log asset path to verify correct import
    if (kDebugMode) {
      debugPrint('🔍 Car make: $carMake');
      debugPrint(
        '🔍 Loading car logo from: ${logoPath ?? "null (fallback to icon)"}',
      );
    }

    // If no logo path found, show fallback icon
    if (logoPath == null) {
      if (kDebugMode) {
        debugPrint('⚠️ No logo found for car make: $carMake');
      }
      return Icon(
        Icons.directions_car,
        size: 40.sp,
        color: AppColors.secondaryText,
      );
    }

    return Image.asset(
      logoPath,
      height: 40.h,
      width: 40.w,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Debug: Log error if image fails to load
        if (kDebugMode) {
          debugPrint('❌ Error loading car logo for "$carMake": $error');
          debugPrint('❌ Attempted path: $logoPath');
        }
        // Fallback to icon if image not found
        return Icon(
          Icons.directions_car,
          size: 40.sp,
          color: AppColors.secondaryText,
        );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        // Debug: Log successful image load
        if (kDebugMode && frame != null) {
          debugPrint('✅ Car logo loaded successfully for "$carMake"');
        }
        return child;
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.secondaryText),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ColorInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String colorName;
  final AppLocalizations l10n;

  const _ColorInfoRow({
    required this.icon,
    required this.label,
    required this.colorName,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorNameMapper.mapNameToColor(colorName);

    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.secondaryText),
        SizedBox(width: 6.w),
        // Color swatch
        Container(
          width: 18.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            VehicleTranslations.getColorTranslation(colorName, l10n),
            style: AppTextStyles.bodySmall(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
