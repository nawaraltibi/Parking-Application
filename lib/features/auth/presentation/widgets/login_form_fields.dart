import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/auth_validators.dart';

/// Reusable form fields for login
class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.authEmailHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => AuthValidators.email(value, l10n),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.authPasswordLabel,
          hintText: l10n.authPasswordHint,
          controller: passwordController,
          isPassword: true,
          obscureText: true,
          validator: (value) => AuthValidators.password(value, l10n),
        ),
      ],
    );
  }
}

