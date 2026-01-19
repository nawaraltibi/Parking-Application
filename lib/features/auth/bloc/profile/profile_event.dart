part of 'profile_bloc.dart';

/// Base class for profile events
abstract class ProfileEvent {}

/// Event to load user profile data
class LoadProfile extends ProfileEvent {
  LoadProfile();
}

/// Event to update profile information
class UpdateProfile extends ProfileEvent {
  final UpdateProfileRequest request;

  UpdateProfile(this.request);
}

/// Event to update password
class UpdatePassword extends ProfileEvent {
  final UpdatePasswordRequest request;

  UpdatePassword(this.request);
}

/// Event to delete account
class DeleteAccount extends ProfileEvent {
  final DeleteAccountRequest request;

  DeleteAccount(this.request);
}

/// Event to update profile fields in the request
class UpdateProfileField extends ProfileEvent {
  final String? fullName;
  final String? email;
  final String? phone;

  UpdateProfileField({
    this.fullName,
    this.email,
    this.phone,
  });
}

/// Event to reset profile state
class ResetProfileState extends ProfileEvent {
  ResetProfileState();
}

