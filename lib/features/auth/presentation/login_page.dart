import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/login/login_bloc.dart';
import 'login_screen.dart';

/// Login Page
/// Provides BlocProvider for LoginScreen
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: const LoginScreen(),
    );
  }
}

