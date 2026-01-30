import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/services/bookings_list_refresh_notifier.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../booking/bloc/bookings_list/bookings_list_bloc.dart';
import '../../../booking/presentation/widgets/booking_card.dart';

/// User Bookings Page
/// Displays active and completed bookings with tabs
class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({super.key});

  @override
  State<UserBookingsPage> createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BookingsListBloc? _cachedBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabIndexChanged);
  }

  void _onTabIndexChanged() {
    if (_tabController.indexIsChanging) return;
    _cachedBloc?.add(
      _tabController.index == 0
          ? const LoadActiveBookings()
          : const LoadFinishedBookings(),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabIndexChanged);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabContent(
    BuildContext blocContext,
    AppLocalizations l10n,
    {required bool isActiveTab}
  ) {
    return BlocBuilder<BookingsListBloc, BookingsListState>(
      builder: (blocContext, state) {
        if (state is BookingsListLoading) {
          return const Center(child: LoadingWidget());
        }

        if (state is BookingsListError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              blocContext.read<BookingsListBloc>().add(
                isActiveTab
                    ? const LoadActiveBookings()
                    : const LoadFinishedBookings(),
              );
            },
          );
        }

        if (state is BookingsListLoaded && state.isActiveTab == isActiveTab) {
          return RefreshIndicator(
            onRefresh: () async {
              blocContext.read<BookingsListBloc>().add(
                const RefreshBookings(),
              );
            },
            child: state.hasBookings
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.w,
                          20.h,
                          20.w,
                          12.h,
                        ),
                        child: Text(
                          l10n.listOfBookings,
                          style: AppTextStyles.titleMedium(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: state.bookings.length,
                          itemBuilder: (context, index) {
                            return BookingCard(
                              booking: state.bookings[index],
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_parking_outlined,
                                size: 64.sp,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                isActiveTab
                                    ? l10n.noActiveBookings
                                    : l10n.noFinishedBookings,
                                style: AppTextStyles.bodyLarge(
                                  context,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }

        if (state is BookingsListLoaded && state.isActiveTab != isActiveTab) {
          return const Center(child: LoadingWidget());
        }

        return const Center(child: LoadingWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) {
        final bloc = getIt<BookingsListBloc>();
        bloc.add(const LoadActiveBookings());
        return bloc;
      },
      child: _BookingsRefreshListener(
        child: Builder(
          builder: (blocContext) {
            _cachedBloc ??= blocContext.read<BookingsListBloc>();
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text(
                  l10n.userTabBookings,
                  style: AppTextStyles.titleLarge(context),
                ),
                backgroundColor: AppColors.background,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        if (index == 0) {
                          blocContext.read<BookingsListBloc>().add(
                            const LoadActiveBookings(),
                          );
                        } else {
                          blocContext.read<BookingsListBloc>().add(
                            const LoadFinishedBookings(),
                          );
                        }
                      },
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: AppColors.textOnPrimary,
                      unselectedLabelColor: AppColors.secondaryText,
                      labelStyle: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: AppTextStyles.bodyMedium(context),
                      tabs: [
                        Tab(text: l10n.activeBookings),
                        Tab(text: l10n.completedBookings),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(
                    blocContext,
                    l10n,
                    isActiveTab: true,
                  ),
                  _buildTabContent(
                    blocContext,
                    l10n,
                    isActiveTab: false,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// يستمع لـ [BookingsListRefreshNotifier] ويطلق [RefreshBookings] عند الطلب.
class _BookingsRefreshListener extends StatefulWidget {
  final Widget child;

  const _BookingsRefreshListener({required this.child});

  @override
  State<_BookingsRefreshListener> createState() =>
      _BookingsRefreshListenerState();
}

class _BookingsRefreshListenerState extends State<_BookingsRefreshListener> {
  @override
  void initState() {
    super.initState();
    getIt<BookingsListRefreshNotifier>().addListener(_onRefreshRequested);
  }

  void _onRefreshRequested() {
    if (!mounted) return;
    context.read<BookingsListBloc>().add(const RefreshBookings());
  }

  @override
  void dispose() {
    getIt<BookingsListRefreshNotifier>().removeListener(_onRefreshRequested);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
