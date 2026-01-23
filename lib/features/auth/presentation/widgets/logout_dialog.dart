import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

/// Logout Confirmation Dialog
/// Confirmation dialog for logout action
class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400.w,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      l10n.authLogoutDialogTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge(context),
                    ),
                    SizedBox(height: 16.h),
                    // Content
                    Text(
                      l10n.authLogoutDialogMessage,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Actions
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: CustomElevatedButton(
                            title: l10n.authLogoutDialogCancel,
                            onPressed: () => Navigator.of(context).pop(),
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.primary,
                            useGradient: false,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Logout Button
                        Expanded(
                          child: CustomElevatedButton(
                            title: l10n.authLogoutDialogConfirm,
                            onPressed: () {
                              Navigator.of(context).pop();
                              onConfirm();
                            },
                            backgroundColor: AppColors.error,
                            foregroundColor: AppColors.textOnPrimary,
                            useGradient: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Show logout confirmation dialog
  static void show(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(onConfirm: onConfirm),
    );
  }
}

