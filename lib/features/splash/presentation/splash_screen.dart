import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../bloc/splash_routing_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/assets/assets.dart';

/// Splash Screen Widget
/// Displays loading animation and handles navigation based on authentication status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();

    // Start animation after a short delay
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashRoutingBloc, SplashRoutingState>(
      listener: (context, state) async {
        if (state is SplashLoaded) {
          // Store references before async operations
          final route = () {
            switch (state.destination) {
              case SplashDestination.onboarding:
                return Routes.onboardingPath;
              case SplashDestination.ownerMain:
                return Routes.ownerMainPath;
              case SplashDestination.userMain:
                return Routes.userMainPath;
              case SplashDestination.unauthenticated:
                return Routes.loginPath;
            }
          }();
          final router = GoRouter.of(context);
          
          // Wait for animation to complete if needed
          if (!_showContent) {
            await Future.delayed(const Duration(seconds: 2));
          }
          await Future.delayed(const Duration(seconds: 2));
          
          if (!mounted) return;
          router.go(route);
        } else if (state is SplashError) {
          if (!mounted) return;
          // On error, retry checking status
          context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      Assets.imagesLogo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // App Name
                // Text(
                //   'Mawaqef',
                //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //         shadows: [
                //           Shadow(
                //             color: Colors.black.withValues(alpha: 0.5),
                //             blurRadius: 4,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                // ),
                const SizedBox(height: 48),
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

