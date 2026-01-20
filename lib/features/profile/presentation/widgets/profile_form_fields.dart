import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/profile_validators.dart';

/// Reusable form fields for profile edit
class ProfileFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final bool enabled;

  const ProfileFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: l10n.authFullNameLabel,
          hintText: l10n.authFullNameHint,
          controller: fullNameController,
          enabled: enabled,
          validator: (value) => ProfileValidators.fullName(value, l10n),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.authEmailHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: enabled,
          validator: (value) => ProfileValidators.email(value, l10n),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.authPhoneLabel,
          hintText: l10n.authPhoneHint,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          enabled: enabled,
          validator: (value) => ProfileValidators.phone(value, l10n),
        ),
      ],
    );
  }
}

