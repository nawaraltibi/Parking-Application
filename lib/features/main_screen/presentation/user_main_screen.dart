import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/user_main/user_main_bloc.dart';
import '../models/user_tab.dart';
import '../widgets/modern_bottom_nav_bar.dart';
import '../../profile/presentation/profile_page.dart';
import 'pages/user_home_page.dart';
import 'pages/user_vehicles_page.dart';
import 'pages/user_parkings_page.dart';

/// User Main Screen
/// Main screen for regular users with bottom navigation
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen>
    with AutomaticKeepAliveClientMixin<UserMainScreen> {
  late PageController _pageController;
  static const _navDuration = Duration(milliseconds: 300);

  static List<UserTab> get _bottomNavTabs => [
        UserTab.home,
        UserTab.vehicles,
        UserTab.parkings,
        UserTab.profile,
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: _navDuration,
      curve: Curves.fastOutSlowIn,
    );
    context.read<UserMainBloc>().add(ChangeUserTab(index));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UserMainBloc, UserMainState>(
      listener: (context, state) {
        final selectedIndex = _mapSelectedIndex(state);
        if (_pageController.hasClients) {
          final currentPage = _pageController.page?.round() ?? 0;
          if (currentPage != selectedIndex) {
            _pageController.animateToPage(
              selectedIndex,
              duration: _navDuration,
              curve: Curves.fastOutSlowIn,
            );
          }
        }
      },
      child: BlocSelector<UserMainBloc, UserMainState, int>(
        selector: _mapSelectedIndex,
        builder: (context, selectedIndex) {
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  UserHomePage(),
                  UserVehiclesPage(),
                  UserParkingsPage(),
                  ProfilePage(),
                ],
              ),
            ),
            bottomNavigationBar: ModernBottomNavBar(
              items: _bottomNavTabs.map((tab) {
                return ModernNavItem(
                  icon: tab.icon,
                  label: tab.label(l10n),
                  // Use filled icons for active state
                  activeIcon: _getActiveIcon(tab.icon, tab),
                );
              }).toList(),
              selectedIndex: _mapBottomNavIndex(selectedIndex),
              onTap: (index) {
                final tab = _bottomNavTabs[index];
                final actualIndex = tab.index;
                _goToPage(actualIndex);
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              unselectedColor: AppColors.secondaryText,
              height: 58,
              showLabels: true,
              elevation: 12,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

int _mapSelectedIndex(UserMainState state) {
  return state is UserMainInitial ? state.selectedIndex : 0;
}

int _mapBottomNavIndex(int actualIndex) {
  final tab = UserTab.values[actualIndex];
  final bottomNavIndex = _UserMainScreenState._bottomNavTabs.indexOf(tab);
  return bottomNavIndex >= 0 ? bottomNavIndex : 0;
}

/// Helper function to get filled/active icon variant based on tab
IconData _getActiveIcon(IconData outlinedIcon, UserTab tab) {
  // Map tabs to their filled icon variants for active state
  switch (tab) {
    case UserTab.home:
      return Icons.home;
    case UserTab.vehicles:
      return Icons.directions_car;
    case UserTab.parkings:
      return Icons.bookmark;
    case UserTab.profile:
      return Icons.person;
  }
}

