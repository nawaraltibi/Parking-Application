import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Booking Details Screen
/// Displays booking details (placeholder for now)
class BookingDetailsScreen extends StatelessWidget {
  final int bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
            size: 24.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.bookingDetails,
          style: AppTextStyles.titleLarge(
            context,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64.sp,
              color: AppColors.secondaryText,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.bookingDetails,
              style: AppTextStyles.titleLarge(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${l10n.bookingId}: $bookingId',
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.placeholderComingSoon,
              style: AppTextStyles.bodySmall(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

