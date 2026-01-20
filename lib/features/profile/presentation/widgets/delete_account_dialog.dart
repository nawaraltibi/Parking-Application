import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/delete_account_request.dart';
import '../utils/profile_validators.dart';

/// Delete Account Dialog
/// Dialog for confirming account deletion
class DeleteAccountDialog extends StatefulWidget {
  final Function(DeleteAccountRequest) onConfirm;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
  });

  static void show(
    BuildContext context,
    Function(DeleteAccountRequest) onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteAccountDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleDelete() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = DeleteAccountRequest(
        password: _passwordController.text,
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
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Warning Icon
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),

                      // Title
                      Text(
                        l10n.profileDeleteAccountDialogTitle,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),

                      // Message
                      Text(
                        l10n.profileDeleteAccountDialogMessage,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(height: 24.h),

                      // Password Field
                      CustomTextField(
                        label: l10n.profileDeleteAccountPasswordLabel,
                        hintText: l10n.profileDeleteAccountPasswordHint,
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) => ProfileValidators.password(value, l10n),
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
                              title: l10n.profileDeleteAccountDialogConfirm,
                              isLoading: _isLoading,
                              onPressed: _handleDelete,
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
            ),
          );
        },
      ),
    );
  }
}

