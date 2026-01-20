import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/owner_main/owner_main_bloc.dart';
import '../models/owner_tab.dart';
import '../widgets/modern_bottom_nav_bar.dart';
import '../../profile/presentation/profile_page.dart';
import 'pages/owner_parking_management_page.dart';

/// Owner Main Screen
/// Main screen for parking owners with bottom navigation
class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({super.key});

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen>
    with AutomaticKeepAliveClientMixin<OwnerMainScreen> {
  late PageController _pageController;
  static const _navDuration = Duration(milliseconds: 300);

  static List<OwnerTab> get _bottomNavTabs => [
        OwnerTab.parkingManagement,
        OwnerTab.profile,
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
    context.read<OwnerMainBloc>().add(ChangeOwnerTab(index));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<OwnerMainBloc, OwnerMainState>(
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
      child: BlocSelector<OwnerMainBloc, OwnerMainState, int>(
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
                  OwnerParkingManagementPage(),
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

int _mapSelectedIndex(OwnerMainState state) {
  return state is OwnerMainInitial ? state.selectedIndex : 0;
}

int _mapBottomNavIndex(int actualIndex) {
  final tab = OwnerTab.values[actualIndex];
  final bottomNavIndex = _OwnerMainScreenState._bottomNavTabs.indexOf(tab);
  return bottomNavIndex >= 0 ? bottomNavIndex : 0;
}

/// Helper function to get filled/active icon variant based on tab
IconData _getActiveIcon(IconData outlinedIcon, OwnerTab tab) {
  // Use active icon from OwnerTab extension
  return tab.activeIcon;
}

