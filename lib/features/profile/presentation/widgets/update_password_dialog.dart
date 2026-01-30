import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/update_password_request.dart';
import '../utils/profile_validators.dart';

/// Update Password Dialog
/// Dialog for updating user password
class UpdatePasswordDialog extends StatefulWidget {
  final Function(UpdatePasswordRequest) onConfirm;

  const UpdatePasswordDialog({
    super.key,
    required this.onConfirm,
  });

  static void show(
    BuildContext context,
    Function(UpdatePasswordRequest) onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdatePasswordDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<UpdatePasswordDialog> createState() => _UpdatePasswordDialogState();
}

class _UpdatePasswordDialogState extends State<UpdatePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = UpdatePasswordRequest(
        password: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmPasswordController.text,
      );

      widget.onConfirm(request);
      
      // Close dialog after a short delay to allow bloc to process
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400.w,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Container(
              padding: EdgeInsetsDirectional.all(24.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        l10n.profileUpdatePasswordDialogTitle,
                        style: AppTextStyles.titleLarge(context),
                      ),
                      SizedBox(height: 24.h),

                      // Current Password Field
                      CustomTextField(
                        label: l10n.profileCurrentPasswordLabel,
                        hintText: l10n.profileCurrentPasswordHint,
                        controller: _currentPasswordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) => ProfileValidators.password(value, l10n),
                      ),
                      SizedBox(height: 16.h),

                      // New Password Field
                      CustomTextField(
                        label: l10n.profileNewPasswordLabel,
                        hintText: l10n.profileNewPasswordHint,
                        controller: _newPasswordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) => ProfileValidators.passwordWithLength(value, l10n),
                      ),
                      SizedBox(height: 16.h),

                      // Confirm New Password Field
                      CustomTextField(
                        label: l10n.profileConfirmNewPasswordLabel,
                        hintText: l10n.profileConfirmNewPasswordHint,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) => ProfileValidators.passwordConfirmation(
                          value,
                          _newPasswordController.text,
                          l10n,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              title: l10n.profileCancelButton,
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.primaryText,
                              useGradient: false,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomElevatedButton(
                              title: l10n.profileSaveButton,
                              isLoading: _isLoading,
                              onPressed: _handleUpdate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

