import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../../parking/models/parking_model.dart';

/// Booking Pre-Payment Header Widget
/// Displays parking image banner with title overlay
class BookingPrePaymentHeader extends StatelessWidget {
  final ParkingModel parking;

  const BookingPrePaymentHeader({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Parking Image Banner with dark overlay - Smaller height
        Container(
          height: 140.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Parking Image
                Image.asset(
                  'assets/images/parking.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Center(
                        child: Icon(
                          EvaIcons.imageOutline,
                          size: 64.sp,
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  },
                ),
                // Dark overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.r),
                      bottomRight: Radius.circular(24.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Title Overlay - Centered vertically in the middle of the image
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.textOnPrimary,
                    size: 24.sp,
                  ),
                  onPressed: () async {
                    // Get user type and navigate to appropriate main screen
                    final userType = await AuthLocalRepository.getUserType();
                    final mainScreenPath = userType == 'owner'
                        ? Routes.ownerMainPath
                        : Routes.userMainPath;

                    // Use pushReplacement to navigate to main screen
                    if (context.mounted) {
                      GoRouter.of(context).pushReplacement(mainScreenPath);
                    }
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.bookingPrePaymentTitle,
                      style: AppTextStyles.titleLarge(
                        context,
                        color: AppColors.textOnPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Spacer to balance the back button
                SizedBox(width: 48.w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
