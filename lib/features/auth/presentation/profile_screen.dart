import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/logout/logout_bloc.dart';
import '../models/profile_data_response.dart';
import '../models/update_profile_request.dart';
import '../models/update_password_request.dart';
import '../models/delete_account_request.dart';
import 'widgets/update_password_dialog.dart';
import 'widgets/delete_account_dialog.dart';
import 'widgets/logout_dialog.dart';

/// Profile Screen
/// UI component for displaying and managing user profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _controllersInitialized = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Initialize controllers with profile data (only once)
  void _initializeControllers(ProfileDataResponse profileData) {
    if (!_controllersInitialized) {
      _fullNameController.text = profileData.data.fullName;
      _emailController.text = profileData.data.email;
      _phoneController.text = profileData.data.phone;
      _controllersInitialized = true;
    }
  }

  void _startEditing(ProfileDataResponse profileData) {
    setState(() {
      _isEditing = true;
      // Update controllers with current profile data when entering edit mode
      _fullNameController.text = profileData.data.fullName;
      _emailController.text = profileData.data.email;
      _phoneController.text = profileData.data.phone;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
    context.read<ProfileBloc>().add(ResetProfileState());
  }

  void _saveProfile() {
    final request = UpdateProfileRequest(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    context.read<ProfileBloc>().add(UpdateProfile(request));
  }

  void _showUpdatePasswordDialog() {
    UpdatePasswordDialog.show(context, (UpdatePasswordRequest request) {
      context.read<ProfileBloc>().add(UpdatePassword(request));
    });
  }

  void _showDeleteAccountDialog() {
    DeleteAccountDialog.show(context, (DeleteAccountRequest request) {
      context.read<ProfileBloc>().add(DeleteAccount(request));
    });
  }

  void _showLogoutDialog() {
    LogoutDialog.show(context, () {
      context.read<LogoutBloc>().add(LogoutRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.authProfileTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdateSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessUpdate,
                  );
                  setState(() {
                    _isEditing = false;
                  });
                  // Update controllers with new profile data after successful update
                  if (state.profileData != null) {
                    _fullNameController.text = state.profileData!.data.fullName;
                    _emailController.text = state.profileData!.data.email;
                    _phoneController.text = state.profileData!.data.phone;
                  }
                  // Reload profile to show updated data
                  context.read<ProfileBloc>().add(LoadProfile());
                } else if (state is PasswordUpdateSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessPasswordUpdate,
                  );
                  // Navigate to login after password update (tokens are invalidated)
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      context.pushReplacement(Routes.loginPath);
                    }
                  });
                } else if (state is AccountDeleteSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessDeleteAccount,
                  );
                  // Navigate to login after account deletion
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      context.pushReplacement(Routes.loginPath);
                    }
                  });
                } else if (state is ProfileFailure) {
                  String errorMessage = state.error;

                  // Translate known error messages
                  if (state.statusCode == 422) {
                    if (errorMessage.contains('incorrect password') ||
                        errorMessage.contains('Incorrect password')) {
                      errorMessage = l10n.profileErrorIncorrectPassword;
                    } else if (errorMessage.contains(
                          'Passwords do not match',
                        ) ||
                        errorMessage.contains('password mismatch')) {
                      errorMessage = l10n.profileErrorPasswordMismatch;
                    } else if (errorMessage.contains('email') &&
                            errorMessage.contains('already') ||
                        errorMessage.contains('taken')) {
                      errorMessage = l10n.profileErrorEmailExists;
                    }
                  }

                  UnifiedSnackbar.error(context, message: errorMessage);
                }
              },
            ),
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.authSuccessLogout,
                  );
                  // Navigate to login screen after logout
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      context.pushReplacement(Routes.loginPath);
                    }
                  });
                } else if (state is LogoutFailure) {
                  // Handle 401 (Unauthenticated) - clear data and navigate
                  if (state.statusCode == 401) {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        context.pushReplacement(Routes.loginPath);
                      }
                    });
                  } else {
                    // Show error for other status codes (500, etc.)
                    UnifiedSnackbar.error(context, message: state.error);
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading && state.updateRequest == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.profileLoading,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProfileFailure && state.updateRequest == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.error,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      CustomElevatedButton(
                        title: l10n.profileRetryButton,
                        onPressed: () {
                          context.read<ProfileBloc>().add(LoadProfile());
                        },
                      ),
                    ],
                  ),
                );
              }

              ProfileDataResponse? profileData;
              if (state is ProfileLoaded) {
                profileData = state.profileData;
              } else if (state is ProfileUpdateSuccess &&
                  state.profileData != null) {
                profileData = state.profileData;
              }

              if (profileData == null) {
                // Initial load
                if (state is ProfileInitial) {
                  context.read<ProfileBloc>().add(LoadProfile());
                }
                return const SizedBox.shrink();
              }

              // Initialize controllers with profile data (only once)
              _initializeControllers(profileData);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),

                    // Profile Info Card
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Type Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              profileData.data.userType.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Full Name Field
                          CustomTextField(
                            label: l10n.authFullNameLabel,
                            hintText: l10n.authFullNameHint,
                            controller: _fullNameController,
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.authValidationFullNameRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Email Field
                          CustomTextField(
                            label: l10n.authEmailLabel,
                            hintText: l10n.authEmailHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.authValidationEmailRequired;
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return l10n.authValidationEmailInvalid;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Phone Field
                          CustomTextField(
                            label: l10n.authPhoneLabel,
                            hintText: l10n.authPhoneHint,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.authValidationPhoneRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Number of Vehicles (Read-only)
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.profileNumberOfVehicles,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  '${profileData.data.numberOfVehicles}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: profileData.data.status == 'active'
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              profileData.data.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: profileData.data.status == 'active'
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Edit/Save/Cancel Buttons
                    if (_isEditing) ...[
                      CustomElevatedButton(
                        title: l10n.profileSaveButton,
                        isLoading: state is ProfileLoading,
                        onPressed: _saveProfile,
                      ),
                      SizedBox(height: 12.h),
                      CustomElevatedButton(
                        title: l10n.profileCancelButton,
                        onPressed: _cancelEditing,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primaryText,
                        useGradient: false,
                      ),
                    ] else ...[
                      CustomElevatedButton(
                        title: l10n.profileEditButton,
                        onPressed: () {
                          if (profileData != null) {
                            _startEditing(profileData);
                          }
                        },
                        icon: const Icon(Icons.edit, size: 20),
                      ),
                    ],
                    SizedBox(height: 16.h),

                    // Update Password Button
                    CustomElevatedButton(
                      title: l10n.profileUpdatePasswordButton,
                      onPressed: _showUpdatePasswordDialog,
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary,
                      useGradient: false,
                      icon: const Icon(Icons.lock_outline, size: 20),
                    ),
                    SizedBox(height: 16.h),

                    // Logout Button
                    BlocBuilder<LogoutBloc, LogoutState>(
                      builder: (context, logoutState) {
                        return CustomElevatedButton(
                          title: l10n.authLogoutButton,
                          isLoading: logoutState is LogoutLoading,
                          onPressed: _showLogoutDialog,
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.warning,
                          useGradient: false,
                          icon: const Icon(Icons.logout, size: 20),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Delete Account Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.error, width: 1.5),
                      ),
                      child: CustomElevatedButton(
                        title: l10n.profileDeleteAccountButton,
                        onPressed: _showDeleteAccountDialog,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.error,
                        useGradient: false,
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
