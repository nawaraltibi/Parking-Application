import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/parking_model.dart';

/// Parking Card Widget
/// Displays parking lot information in a card format with status badge
class ParkingCard extends StatelessWidget {
  final ParkingModel parking;
  final VoidCallback onTap;

  const ParkingCard({
    super.key,
    required this.parking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      parking.lotName,
                      style: AppTextStyles.cardTitle(context),
                    ),
                  ),
                  _buildStatusBadge(context, l10n),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    EvaIcons.pin,
                    size: 16.sp,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      parking.address,
                      style: AppTextStyles.cardSubtitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    icon: EvaIcons.car,
                    label: '${parking.totalSpaces} ${l10n.parkingDashboardTotalSpaces}',
                  ),
                  SizedBox(width: 8.w),
                  _buildInfoChip(
                    context,
                    icon: EvaIcons.creditCard,
                    label: '${parking.hourlyRate.toStringAsFixed(2)}/hr',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, AppLocalizations l10n) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    if (parking.isRejected) {
      backgroundColor = AppColors.error.withValues(alpha: 0.1);
      textColor = AppColors.error;
      statusText = l10n.parkingStatusRejected;
    } else if (parking.isPending) {
      backgroundColor = AppColors.warning.withValues(alpha: 0.1);
      textColor = AppColors.warning;
      statusText = l10n.parkingStatusPending;
    } else if (parking.isApproved && parking.isActive) {
      backgroundColor = AppColors.success.withValues(alpha: 0.1);
      textColor = AppColors.success;
      statusText = l10n.parkingStatusActive;
    } else {
      backgroundColor = AppColors.secondaryText.withValues(alpha: 0.1);
      textColor = AppColors.secondaryText;
      statusText = l10n.parkingStatusInactive;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.labelSmall(
          context,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: AppColors.secondaryText,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.bodySmall(
              context,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

