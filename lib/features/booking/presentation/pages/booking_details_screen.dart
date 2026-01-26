import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/booking_details/booking_details_bloc.dart';
import '../../bloc/booking_action/booking_action_bloc.dart';
import '../../models/remaining_time_response.dart';
import '../../repository/booking_repository.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../widgets/remaining_time_card.dart';
import '../widgets/booking_info_card.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/time_info_section.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/booking_action_buttons.dart';

/// Booking Details Screen
/// Displays active/completed booking details with real-time remaining time
class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late final BookingDetailsBloc _bookingDetailsBloc;

  @override
  void initState() {
    super.initState();
    _bookingDetailsBloc = BookingDetailsBloc();
    
    // Load booking details
    // Use WidgetsBinding to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bookingDetailsBloc.add(LoadBookingDetails(bookingId: widget.bookingId));
    });
    
    // Start remaining time timer for active bookings
    // Timer will be started after booking details are loaded
  }

  @override
  void dispose() {
    // Stop timer when screen is disposed
    _bookingDetailsBloc.add(const StopRemainingTimeTimer());
    _bookingDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bookingDetailsBloc),
        BlocProvider(create: (context) => getIt<BookingActionBloc>()),
      ],
      child: BlocListener<BookingActionBloc, BookingActionState>(
        listener: (context, state) {
          if (state is BookingActionSuccess) {
            if (state.action == BookingActionType.cancel) {
              // Stop any ongoing timers or data loading
              _bookingDetailsBloc.add(const StopRemainingTimeTimer());
              
              // Show success message
              UnifiedSnackbar.success(
                context,
                message: state.message,
              );
              
              // Navigate to home/main screen immediately after cancellation
              // Use go() to clear navigation stack and go to main screen
              // No delay to avoid showing error state
              if (context.mounted) {
                context.go(Routes.userMainPath);
              }
            }
          } else if (state is BookingActionFailure) {
            if (state.action == BookingActionType.cancel) {
              // Show error message
              UnifiedSnackbar.error(
                context,
                message: state.error,
              );
            }
          }
        },
        child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryText,
              size: 24.sp,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.bookingDetails,
            style: AppTextStyles.titleLarge(
              context,
              color: AppColors.primaryText,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocListener<BookingDetailsBloc, BookingDetailsState>(
          listener: (context, state) {
            // Start timer when booking details are loaded and booking is active
            if (state is BookingDetailsLoaded) {
              final booking = state.response.data;
              if (booking != null && booking.isActive) {
                _bookingDetailsBloc.add(
                  StartRemainingTimeTimer(bookingId: widget.bookingId),
                );
              }
            }
          },
          listenWhen: (previous, current) {
            // Only listen to BookingDetailsLoaded states
            return current is BookingDetailsLoaded;
          },
          child: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
            builder: (context, state) {
              // Debug: Print current state
              print('BookingDetailsScreen state: ${state.runtimeType}');
              
              if (state is BookingDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BookingDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium(
                          context,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () {
                          _bookingDetailsBloc.add(
                            LoadBookingDetails(bookingId: widget.bookingId),
                          );
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              // Handle both BookingDetailsLoaded and RemainingTimeUpdated states
              BookingDetailsLoaded? bookingState;
              RemainingTimeResponse? remainingTime;
              bool hasWarning = false;
              bool hasExpired = false;

              if (state is RemainingTimeUpdated) {
                // State includes both booking details and remaining time
                bookingState = state;
                remainingTime = state.remainingTimeResponse;
                hasWarning = state.hasWarning;
                hasExpired = state.hasExpired;
              } else if (state is BookingDetailsLoaded) {
                // Only booking details loaded, no remaining time yet
                bookingState = state;
              } else if (state is RemainingTimeLoaded) {
                // Remaining time loaded but we need booking details
                // This shouldn't happen if flow is correct, but handle it
                // Try to get booking details from a stored reference or reload
                // For now, just reload booking details
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _bookingDetailsBloc.add(LoadBookingDetails(bookingId: widget.bookingId));
                });
                // Show loading while we reload booking details
                return const Center(child: CircularProgressIndicator());
              } else {
                // Not in a loaded state, show loading
                return const Center(child: CircularProgressIndicator());
              }

              final booking = bookingState.response.data;
              if (booking == null) {
                return Center(
                  child: Text(
                    l10n.bookingNotFound,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.error,
                    ),
                  ),
                );
              }

              // Check if booking is active or pending
              // After payment, booking might be pending initially, then become active
              final isActive = booking.isActive;
              final isPending = booking.isPending;
              
              // Show action buttons for active bookings only
              // Pending bookings don't have extend/cancel options
              final showActionButtons = isActive;

              return Column(
                children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Success Banner (if booking is active)
                            if (isActive)
                              Container(
                                padding: EdgeInsets.all(16.w),
                                margin: EdgeInsets.only(bottom: 20.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: 24.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        l10n.bookingCreatedSuccess,
                                        style: AppTextStyles.bodyMedium(
                                          context,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Remaining Time Card (only for active bookings)
                            if (isActive)
                              RemainingTimeCard(
                                remainingTime: remainingTime,
                                isLoading: false,
                                hasWarning: hasWarning,
                                hasExpired: hasExpired,
                                startTime: booking.startTime.isNotEmpty
                                    ? DateTime.tryParse(booking.startTime)
                                    : null,
                                endTime: booking.endTime.isNotEmpty
                                    ? DateTime.tryParse(booking.endTime)
                                    : null,
                              ),
                            
                            if (isActive && !isPending) SizedBox(height: 20.h),

                            // Booking Info Card
                            BookingInfoCard(booking: booking),
                            SizedBox(height: 20.h),

                            // Vehicle Info Card
                            VehicleInfoCard(booking: booking),
                            SizedBox(height: 20.h),

                            // Time Info Section
                            TimeInfoSection(booking: booking),
                            SizedBox(height: 20.h),

                            // Payment Summary Card
                            PaymentSummaryCard(booking: booking),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),

                    // Fixed Bottom Action Buttons
                    BookingActionButtons(
                      isActive: showActionButtons,
                      onExtendBooking: showActionButtons
                          ? () {
                              // Navigate to extend booking screen
                              final booking = bookingState?.response.data;
                              if (booking != null) {
                                context.push(
                                  Routes.extendBookingPath,
                                  extra: booking,
                                );
                              }
                            }
                          : null,
                      onViewInvoice: () => _downloadInvoice(context, booking.bookingId),
                      onCancelBooking: showActionButtons
                          ? () => _showCancelBookingDialog(context)
                          : null,
                    ),
                  ],
                );
            },
          ),
        ),
      ),
      ),
    );
  }

  /// Download invoice PDF
  Future<void> _downloadInvoice(BuildContext context, int bookingId) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                l10n.downloadingInvoice,
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Get download directory
      Directory? downloadDir;
      if (Platform.isAndroid) {
        // For Android, use external storage downloads directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Navigate to Downloads folder
          downloadDir = Directory('${externalDir.path.split('/Android')[0]}/Download');
          if (!await downloadDir.exists()) {
            downloadDir = await getExternalStorageDirectory();
          }
        } else {
          downloadDir = await getApplicationDocumentsDirectory();
        }
      } else {
        // For iOS, use documents directory
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (downloadDir == null) {
        throw Exception('Could not access download directory');
      }

      // Create file path
      final fileName = 'invoice_$bookingId.pdf';
      final filePath = '${downloadDir.path}/$fileName';

      // Download PDF
      await BookingRepository.downloadBookingPdf(
        bookingId: bookingId,
        savePath: filePath,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Open the downloaded file
      final result = await OpenFilex.open(filePath);

      if (context.mounted) {
        if (result.type == ResultType.done) {
          UnifiedSnackbar.show(
            context,
            message: l10n.invoiceDownloaded,
            type: SnackbarType.success,
          );
        } else {
          UnifiedSnackbar.show(
            context,
            message: l10n.errorOpeningFile,
            type: SnackbarType.error,
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Show error message
      if (context.mounted) {
        UnifiedSnackbar.show(
          context,
          message: l10n.errorOpeningFile,
          type: SnackbarType.error,
        );
      }
    }
  }

  /// Show cancel booking confirmation dialog
  void _showCancelBookingDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          l10n.cancelBooking,
          style: AppTextStyles.titleLarge(
            context,
            color: AppColors.primaryText,
          ),
        ),
        content: Text(
          l10n.cancelBookingConfirmation,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _confirmCancelBooking(context);
            },
            child: Text(
              l10n.confirm,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirm and cancel booking
  void _confirmCancelBooking(BuildContext context) {
    final bookingState = _bookingDetailsBloc.state;
    if (bookingState is! BookingDetailsLoaded) {
      return;
    }

    final booking = bookingState.response.data;
    if (booking == null) {
      return;
    }

    context.read<BookingActionBloc>().add(
          CancelBooking(bookingId: booking.bookingId),
        );
  }
}
