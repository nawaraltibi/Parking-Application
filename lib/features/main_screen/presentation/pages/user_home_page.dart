import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking_map/presentation/pages/parking_map_page.dart';
import '../../../booking/bloc/bookings_list/bookings_list_bloc.dart';
import '../../../booking/models/booking_model.dart';
import '../../../booking/models/remaining_time_response.dart';
import '../../../booking/repository/booking_repository.dart';
import '../../../booking/presentation/widgets/active_booking_card.dart';

/// User Home Page
/// Displays parking map with active bookings list
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Timer? _remainingTimeTimer;
  final Map<int, RemainingTimeResponse?> _remainingTimeCache = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _remainingTimeTimer?.cancel();
    super.dispose();
  }

  void _startRemainingTimeTimer(List<BookingModel> activeBookings) {
    _remainingTimeTimer?.cancel();
    
    if (activeBookings.isEmpty) return;

    _remainingTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // Fetch remaining time for all active bookings
      for (final booking in activeBookings) {
        _fetchRemainingTime(booking.bookingId);
      }
    });

    // Fetch immediately
    for (final booking in activeBookings) {
      _fetchRemainingTime(booking.bookingId);
    }
  }

  Future<void> _fetchRemainingTime(int bookingId) async {
    try {
      final response = await BookingRepository.getRemainingTime(
        bookingId: bookingId,
      );
      if (mounted) {
        setState(() {
          _remainingTimeCache[bookingId] = response;
        });
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocProvider<BookingsListBloc>(
      create: (_) {
        final bloc = getIt<BookingsListBloc>();
        // Load active bookings when bloc is created
        bloc.add(const LoadActiveBookings());
        if (kDebugMode) {
          print('🔵 [UserHomePage] BookingsListBloc created, LoadActiveBookings dispatched');
        }
        return bloc;
      },
      child: Stack(
        children: [
          // Map in the background
          const ParkingMapPage(),
          // Active bookings horizontal list overlay above bottom nav bar
          Positioned(
            bottom: 20.h, // Closer to bottom nav bar
            left: 0,
            right: 0,
            child: BlocBuilder<BookingsListBloc, BookingsListState>(
              builder: (context, state) {
                if (state is BookingsListLoaded && state.isActiveTab) {
                  final activeBookings = state.bookings;
                  
                  // Start timer when bookings are loaded
                  if (activeBookings.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _startRemainingTimeTimer(activeBookings);
                    });
                  }

                  if (activeBookings.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Horizontal bookings list with shrinkWrap for dynamic height
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300.h, // Maximum height constraint
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: activeBookings.length,
                      itemBuilder: (context, index) {
                        final booking = activeBookings[index];
                        final remainingTime = _remainingTimeCache[booking.bookingId];
                        
                        return ActiveBookingCard(
                          booking: booking,
                          remainingTime: remainingTime,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

