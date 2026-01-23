import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../core/assets/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/register/register_bloc.dart';
import 'utils/auth_error_handler.dart';
import 'widgets/register_form_fields.dart';

/// Register Screen
/// UI component for user registration
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
  TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedUserType = 'user';

  final List<String> userTypes = ['user', 'owner'];

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }


  void _handleRegister() {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<RegisterBloc>();

      // Update all fields in the bloc state
      bloc.add(UpdateFullName(fullNameController.text.trim()));
      bloc.add(UpdateEmail(emailController.text.trim()));
      bloc.add(UpdatePhone(phoneController.text.trim()));
      bloc.add(UpdateUserType(selectedUserType));
      bloc.add(UpdatePassword(passwordController.text));
      bloc.add(UpdatePasswordConfirmation(passwordConfirmationController.text));

      // Send register request
      bloc.add(SendRegisterRequest());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              UnifiedSnackbar.success(
                context,
                message: state.message,
              );

              // Show appropriate message based on user type
              if (state.response.requiresApproval) {
                // Owner registration - pending approval
                final l10n = AppLocalizations.of(context)!;
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    UnifiedSnackbar.info(
                      context,
                      message: l10n.authSuccessRegisterPending,
                    );
                  }
                });
              }

              // Navigate to login after a short delay
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.pushReplacement(Routes.loginPath);
                }
              });
            } else if (state is RegisterFailure) {
              final l10n = AppLocalizations.of(context)!;
              final errorMessage = AuthErrorHandler.handleRegisterError(
                state.error,
                state.statusCode,
                l10n,
              );
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.h),

                      // Back button
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pushReplacement(Routes.loginPath),
                          color: AppColors.primaryText,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Sign Up Image
                      Center(
                        child: Image.asset(
                          Assets.imagesSignUp,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Register Title
                      Text(
                        l10n.authRegisterTitle,
                        style: AppTextStyles.headlineLarge(
                          context,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.authRegisterSubtitle,
                        style: AppTextStyles.bodyMedium(
                          context,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // Register Form Fields
                      RegisterFormFields(
                        fullNameController: fullNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        passwordController: passwordController,
                        passwordConfirmationController: passwordConfirmationController,
                        selectedUserType: selectedUserType,
                        onUserTypeChanged: (value) {
                          setState(() {
                            selectedUserType = value;
                          });
                        },
                        userTypes: userTypes,
                      ),
                      SizedBox(height: 24.h),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          title: l10n.authRegisterButton,
                          isLoading: state is RegisterLoading,
                          onPressed: _handleRegister,
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.authHaveAccount,
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.pushReplacement(
                                  Routes.loginPath,
                                ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 4.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              l10n.authLoginButton,
                              style: AppTextStyles.labelLarge(
                                context,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}