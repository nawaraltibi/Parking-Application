import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/bloc/locale_cubit.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

/// Language Switcher Tile
/// Allows users to switch between English and Arabic with confirmation
class LanguageSwitcherTile extends StatefulWidget {
  const LanguageSwitcherTile({super.key});

  @override
  State<LanguageSwitcherTile> createState() => _LanguageSwitcherTileState();
}

class _LanguageSwitcherTileState extends State<LanguageSwitcherTile> {
  String? _selectedLanguage; // Selected but not yet applied language

  void _selectLanguage(String newLanguage) {
    // Get current language from context
    final currentLanguage = context.read<LocaleCubit>().currentLocale.languageCode;
    
    if (newLanguage == currentLanguage) {
      // If selecting the current language, clear selection
      setState(() {
        _selectedLanguage = null;
      });
      return;
    }

    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  Future<void> _applyLanguageChange() async {
    if (_selectedLanguage == null) {
      return;
    }

    if (!mounted) return;

    // Use LocaleCubit to change the language
    // This will:
    // 1. Save to SharedPreferences via LanguageService
    // 2. Emit new locale state
    // 3. MaterialApp will rebuild automatically with new locale
    final localeCubit = context.read<LocaleCubit>();
    await localeCubit.changeLanguage(_selectedLanguage!);
    
    // Clear selection after language change
    if (mounted) {
      setState(() {
        _selectedLanguage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Listen to LocaleCubit changes to update UI when locale changes
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final currentLanguage = localeState.locale.languageCode;
        
        return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentLanguage == 'en' ? 'Language' : 'اللغة',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  languageCode: 'en',
                  languageName: 'English',
                  flag: '🇬🇧',
                  isSelected: currentLanguage == 'en',
                  isPending: _selectedLanguage == 'en',
                  onTap: () => _selectLanguage('en'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _LanguageOption(
                  languageCode: 'ar',
                  languageName: 'العربية',
                  flag: '🇸🇦',
                  isSelected: currentLanguage == 'ar',
                  isPending: _selectedLanguage == 'ar',
                  onTap: () => _selectLanguage('ar'),
                ),
              ),
            ],
          ),
          // Show confirmation button only when a different language is selected
          if (_selectedLanguage != null && _selectedLanguage != currentLanguage) ...[
            SizedBox(height: 16.h),
            CustomElevatedButton(
              title: l10n.profileChangeLanguageButton,
              onPressed: _applyLanguageChange,
              icon: const Icon(Icons.language, size: 20),
            ),
          ],
        ],
      ),
        );
      },
    );
  }
}

/// Language Option Widget
class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final String flag;
  final bool isSelected;
  final bool isPending;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.flag,
    required this.isSelected,
    this.isPending = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : isPending
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isPending
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.border,
            width: isSelected || isPending ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected || isPending
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primary
                      : isPending
                          ? AppColors.primary.withValues(alpha: 0.8)
                          : AppColors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Icon(
                Icons.check_circle,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ] else if (isPending) ...[
              SizedBox(width: 6.w),
              Icon(
                Icons.radio_button_checked,
                size: 18.sp,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

