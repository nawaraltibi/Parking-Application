import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) {
        final bloc = getIt<BookingsListBloc>();
        // Load active bookings initially
        bloc.add(const LoadActiveBookings());
        return bloc;
      },
      child: Builder(
        builder: (blocContext) {
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
                      // Handle tap immediately
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
                    labelStyle: AppTextStyles.bodyMedium(context)
                        .copyWith(fontWeight: FontWeight.w600),
                    unselectedLabelStyle: AppTextStyles.bodyMedium(context),
                    tabs: [
                      Tab(text: l10n.activeBookings),
                      Tab(text: l10n.completedBookings),
                    ],
                  ),
                ),
              ),
            ),
            body: BlocBuilder<BookingsListBloc, BookingsListState>(
              builder: (blocContext, state) {
                if (state is BookingsListLoading) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }

                if (state is BookingsListError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () {
                      if (_tabController.index == 0) {
                        blocContext.read<BookingsListBloc>().add(
                              const LoadActiveBookings(),
                            );
                      } else {
                        blocContext.read<BookingsListBloc>().add(
                              const LoadFinishedBookings(),
                            );
                      }
                    },
                  );
                }

                if (state is BookingsListLoaded) {
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
                                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
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
                        : Center(
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
                                  state.isActiveTab
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
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
