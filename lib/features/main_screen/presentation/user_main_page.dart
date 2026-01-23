import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/user_main/user_main_bloc.dart';
import 'user_main_screen.dart';

/// User Main Page
/// Provides BlocProvider for UserMainBloc
class UserMainPage extends StatelessWidget {
  const UserMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get initial tab index from route extra if provided
    final routeState = GoRouterState.of(context);
    final initialTabIndex = routeState.extra as int?;
    
    return BlocProvider(
      create: (context) {
        final bloc = getIt<UserMainBloc>();
        // If initial tab index is provided, set it immediately
        if (initialTabIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bloc.add(ChangeUserTab(initialTabIndex));
          });
        }
        return bloc;
      },
      child: const UserMainScreen(),
    );
  }
}

