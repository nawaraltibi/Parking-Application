import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../repository/auth_repository.dart';
import '../../../../core/utils/app_exception.dart';
import '../mixins/auth_error_handler_mixin.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Login Bloc
/// Manages login state and business logic using Bloc pattern with AsyncRunner
class LoginBloc extends Bloc<LoginEvent, LoginState> with AuthErrorHandlerMixin {
  final AsyncRunner<LoginResponse> loginRunner = AsyncRunner<LoginResponse>();

  LoginBloc() : super(LoginInitial(request: LoginRequest())) {
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePassword>(_onUpdatePassword);
    on<SendLoginRequest>(_onSendLoginRequest);
    on<ResetState>(_onResetState);
  }

  /// Update email in the request
  void _onUpdateEmail(
    UpdateEmail event,
    Emitter<LoginState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      email: event.email,
    );
    emit(LoginInitial(request: updatedRequest));
  }

  /// Update password in the request
  void _onUpdatePassword(
    UpdatePassword event,
    Emitter<LoginState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      password: event.password,
    );
    emit(LoginInitial(request: updatedRequest));
  }

  /// Reset state
  void _onResetState(
    ResetState event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginInitial(request: LoginRequest()));
  }

  /// Send login request to server
  Future<void> _onSendLoginRequest(
    SendLoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    // Validate request locally first
    final validationErrors = state.request.validate();
    if (validationErrors.isNotEmpty) {
      emit(LoginFailure(
        request: state.request,
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(LoginLoading(request: state.request));

    await loginRunner.run(
      onlineTask: (previousResult) async {
        final loginResponse = await AuthRepository.login(
          loginRequest: state.request,
        );
        
        // Validate owner status before saving token
        // Block owner users with inactive status
        if (loginResponse.userType == 'owner' && loginResponse.user.status == 'inactive') {
          // Do not save token or user data
          // Throw exception to be caught in onError
          throw AppException(
            statusCode: 403,
            errorCode: 'owner_pending_approval',
            message: 'Your account is pending admin approval. Please wait until your account is activated.',
          );
        }
        
        // API returned 200 OK with token - login is successful
        // Save token and user data for active users
        await AuthLocalRepository.saveToken(loginResponse.token);
        final userJson = loginResponse.user.toJson();
        // Ensure user_type is saved from loginResponse (it may differ from user object)
        userJson['user_type'] = loginResponse.userType;
        await AuthLocalRepository.saveUser(userJson);
        
        return loginResponse;
      },
      onSuccess: (loginResponse) async {
        if (!emit.isDone) {
          emit(LoginSuccess(
            request: state.request,
            response: loginResponse,
            message: loginResponse.message,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleLoginError(error, emit, state.request);
        }
      },
    );
  }
}
