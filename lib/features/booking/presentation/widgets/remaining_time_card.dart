import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/remaining_time_response.dart';

/// Remaining Time Card Widget
/// Displays live countdown timer for active booking
class RemainingTimeCard extends StatelessWidget {
  final RemainingTimeResponse? remainingTime;
  final bool isLoading;
  final bool hasWarning;
  final bool hasExpired;
  final DateTime? startTime;
  final DateTime? endTime;

  const RemainingTimeCard({
    super.key,
    this.remainingTime,
    this.isLoading = false,
    this.hasWarning = false,
    this.hasExpired = false,
    this.startTime,
    this.endTime,
  });

  /// Format remaining seconds to HH:MM format
  String _formatRemainingTime(int? seconds) {
    if (seconds == null || seconds < 0) return '0h:00m';
    
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    return '${hours}h:${minutes.toString().padLeft(2, '0')}m';
  }

  /// Calculate progress (0.0 to 1.0) based on remaining time
  /// Progress decreases as time passes (1.0 = full time remaining, 0.0 = expired)
  double _calculateProgress(int? remainingSeconds) {
    if (remainingSeconds == null || remainingSeconds <= 0) return 0.0;
    
    // Calculate total duration from start and end time if available
    int totalDuration = 3600; // Default to 1 hour
    
    if (startTime != null && endTime != null) {
      final duration = endTime!.difference(startTime!);
      totalDuration = duration.inSeconds;
    }
    
    if (totalDuration <= 0) return 0.0;
    
    // Progress = remaining time / total duration
    // As time passes, remaining time decreases, so progress decreases
    final progress = remainingSeconds / totalDuration;
    
    // Clamp between 0.0 and 1.0
    if (progress > 1.0) return 1.0;
    if (progress < 0.0) return 0.0;
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final remainingSeconds = remainingTime?.remainingSeconds ?? 0;
    final formattedTime = remainingTime?.remainingTime ?? _formatRemainingTime(remainingSeconds);
    final progress = _calculateProgress(remainingSeconds);
    
    // Determine card color based on state
    Color cardColor = AppColors.surface;
    Color timeColor = AppColors.primaryText;
    Color statusColor = AppColors.success;
    String statusText = l10n.statusActive;

    if (hasExpired) {
      cardColor = AppColors.error.withOpacity(0.1);
      timeColor = AppColors.error;
      statusColor = AppColors.error;
      statusText = l10n.timeExpired;
    } else if (hasWarning || (remainingSeconds < 600 && remainingSeconds > 0)) {
      // Less than 10 minutes
      cardColor = AppColors.warning.withOpacity(0.1);
      timeColor = AppColors.warning;
      statusColor = AppColors.warning;
      statusText = l10n.statusActive;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      color: cardColor,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: hasWarning || hasExpired 
                ? (hasExpired ? AppColors.error : AppColors.warning)
                : AppColors.border,
            width: hasWarning || hasExpired ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.remainingTime,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Remaining time display
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const CircularProgressIndicator(),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedTime,
                    style: AppTextStyles.headlineLarge(
                      context,
                      color: timeColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        hasExpired 
                            ? AppColors.error 
                            : (hasWarning ? AppColors.warning : AppColors.success),
                      ),
                      minHeight: 8.h,
                    ),
                  ),
                  
                  // Warning message if applicable
                  if (hasWarning && !hasExpired) ...[
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16.sp,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            l10n.timeWarning,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

