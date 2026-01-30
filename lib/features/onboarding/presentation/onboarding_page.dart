import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../data/repositories/settings_local_repository.dart';
import '../models/onboarding_page_model.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_indicator.dart';

/// Onboarding Page
/// Displays a multi-screen onboarding flow for first-time users
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Total number of onboarding pages
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to the next page or complete onboarding
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// Skip onboarding and navigate to login
  void _skipOnboarding() {
    _completeOnboarding();
  }

  /// Complete onboarding and navigate to login screen
  void _completeOnboarding() {
    SettingsLocalRepository.markOnboardingCompleted();
    if (mounted) {
      context.go(Routes.loginPath);
    }
  }

  List<OnboardingPageModel> _buildPages(AppLocalizations l10n) {
    return [
      OnboardingPageModel(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDescription1,
        icon: 'location',
      ),
      OnboardingPageModel(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDescription2,
        icon: 'reserve',
      ),
      OnboardingPageModel(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDescription3,
        icon: 'manage',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _buildPages(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at the top
            if (_currentPage < _totalPages - 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: AppTextStyles.bodyLarge(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),
              ),

            // PageView for onboarding screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return OnboardingContent(
                    title: page.title,
                    description: page.description,
                    icon: page.icon,
                  );
                },
              ),
            ),

            // Bottom section with indicators and navigation button
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Page indicators
                  OnboardingIndicator(
                    totalPages: _totalPages,
                    currentPage: _currentPage,
                  ),

                  SizedBox(height: 32.h),

                  // Next/Get Started button - matches app buttons (gradient, shadow, white text)
                  CustomElevatedButton(
                    title: _currentPage < _totalPages - 1
                        ? l10n.next
                        : l10n.getStarted,
                    onPressed: _nextPage,
                    useGradient: true,
                    borderRadius: 16,
                    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
