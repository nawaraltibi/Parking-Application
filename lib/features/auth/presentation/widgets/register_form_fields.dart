import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/auth_validators.dart';

/// Reusable form fields for registration
class RegisterFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final String selectedUserType;
  final ValueChanged<String> onUserTypeChanged;
  final List<String> userTypes;

  const RegisterFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.selectedUserType,
    required this.onUserTypeChanged,
    this.userTypes = const ['user', 'owner'],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name Field
        CustomTextField(
          label: l10n.authFullNameLabel,
          hintText: l10n.authFullNameHint,
          controller: fullNameController,
          prefixIcon: Icon(
            Icons.person_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.name,
          validator: (value) => AuthValidators.fullName(value, l10n),
        ),
        SizedBox(height: 20.h),

        // Email Field
        CustomTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.authEmailHint,
          controller: emailController,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => AuthValidators.email(value, l10n),
        ),
        SizedBox(height: 20.h),

        // Phone Field
        CustomTextField(
          label: l10n.authPhoneLabel,
          hintText: l10n.authPhoneHint,
          controller: phoneController,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => AuthValidators.phone(value, l10n),
        ),
        SizedBox(height: 20.h),

        // User Type Dropdown
        CustomDropdownField<String>(
          label: l10n.authUserTypeLabel,
          items: userTypes,
          selectedValue: selectedUserType,
          getLabel: (value) => value == 'user'
              ? l10n.authUserTypeRegular
              : l10n.authUserTypeOwner,
          onChanged: (value) {
            if (value != null) {
              onUserTypeChanged(value);
            }
          },
        ),
        SizedBox(height: 20.h),

        // Password Field
        CustomTextField(
          label: l10n.authPasswordLabel,
          hintText: l10n.authPasswordRegisterHint,
          controller: passwordController,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
          isPassword: true,
          obscureText: true,
          validator: (value) => AuthValidators.password(value, l10n),
        ),
        SizedBox(height: 20.h),

        // Password Confirmation Field
        CustomTextField(
          label: l10n.authConfirmPasswordLabel,
          hintText: l10n.authConfirmPasswordHint,
          controller: passwordConfirmationController,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
          isPassword: true,
          obscureText: true,
          validator: (value) => AuthValidators.passwordConfirmation(
            value,
            passwordController.text,
            l10n,
          ),
        ),
      ],
    );
  }
}

