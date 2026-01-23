import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/profile/profile_bloc.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import 'profile_screen.dart';

/// Profile Page
/// Provides BlocProviders for ProfileBloc and LogoutBloc
/// Uses AutomaticKeepAliveClientMixin to maintain state
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = getIt<ProfileBloc>();
            // Load profile data immediately when bloc is created
            bloc.add(LoadProfile());
            return bloc;
          },
          lazy: false, // Create immediately, not lazily
        ),
        BlocProvider(
          create: (context) => getIt<LogoutBloc>(),
        ),
      ],
      child: const ProfileScreen(),
    );
  }
}

