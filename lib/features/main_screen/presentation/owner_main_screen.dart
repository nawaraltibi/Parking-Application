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
  int _currentIndex = 0;

  static List<OwnerTab> get _bottomNavTabs => [
        OwnerTab.parkingManagement,
        OwnerTab.profile,
      ];

  void _goToPage(int index) {
    if (_currentIndex == index) return;
    
    // Update BLoC first for immediate UI feedback
    context.read<OwnerMainBloc>().add(ChangeOwnerTab(index));
    
    // Update index for smooth transition
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<OwnerMainBloc, OwnerMainState, int>(
      selector: _mapSelectedIndex,
      builder: (context, selectedIndex) {
        // Sync current index with selected index immediately
        if (_currentIndex != selectedIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _currentIndex != selectedIndex) {
              _goToPage(selectedIndex);
            }
          });
        }
        
        return Scaffold(
            extendBody: true,
            body: SafeArea(
              bottom: true,
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  RepaintBoundary(
                    child: const OwnerParkingManagementPage(),
                  ),
                  RepaintBoundary(
                    child: const ProfilePage(),
                  ),
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

