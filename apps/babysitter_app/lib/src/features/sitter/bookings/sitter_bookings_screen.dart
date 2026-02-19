import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import 'package:babysitter_app/src/routing/routes.dart';
import 'presentation/providers/bookings_providers.dart';
import 'presentation/widgets/booking_card.dart';
import 'presentation/providers/session_tracking_providers.dart';
import '../saved_jobs/presentation/providers/saved_jobs_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Sitter bookings screen
class SitterBookingsScreen extends ConsumerWidget {
  const SitterBookingsScreen({super.key});

  bool _isActiveStatus(String? status) {
    if (status == null) return false;
    final normalized = status.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    return normalized == 'active' || normalized == 'inprogress';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(sitterCurrentBookingsProvider);
    final activeSession = ref.watch(sessionTrackingControllerProvider).session;
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    ref.watch(savedJobsListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go(Routes.sitterHome),
        ),
        title: Text(
          'Bookings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 80,
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                  AppSpacing.verticalMd,
                  Text(
                    'No Bookings Yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  AppSpacing.verticalXs,
                  Text(
                    'Your scheduled sessions will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(sitterCurrentBookingsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final isActive = _isActiveStatus(booking.status);
                final jobId = booking.id;
                final isSaved = savedJobsState.savedJobIds.contains(jobId);
                debugPrint(
                    'DEBUG: BookingCard[$index] - applicationId: ${booking.applicationId}, title: ${booking.title}, status: ${booking.status}');
                return BookingCard(
                  booking: booking,
                  isBookmarked: isSaved,
                  onBookmarkTap: () {
                    if (jobId.isEmpty) {
                      AppToast.show(context,
                        const SnackBar(content: Text('Missing job ID')),
                      );
                      return;
                    }
                    ref
                        .read(savedJobsControllerProvider.notifier)
                        .toggleSaved(jobId)
                        .then((isSaved) {
                      if (!context.mounted) return;
                      AppToast.show(
                        context,
                        SnackBar(
                          content: Text(isSaved ? 'Job saved' : 'Job unsaved'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }).catchError((error) {
                      if (!context.mounted) return;
                      AppToast.show(
                        context,
                        SnackBar(
                          content: Text(error
                              .toString()
                              .replaceFirst('Exception: ', '')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  },
                  onTap: () {
                    debugPrint(
                        'DEBUG: Tapped booking[$index] - applicationId: ${booking.applicationId}');
                    if (activeSession != null &&
                        activeSession.applicationId == booking.applicationId) {
                      final route =
                          '${Routes.sitterActiveBooking}/${booking.applicationId}';
                      debugPrint('DEBUG: Navigating to active booking: $route');
                      context.push(route);
                      return;
                    }
                    if (isActive) {
                      final route =
                          '${Routes.sitterActiveBooking}/${booking.applicationId}';
                      debugPrint('DEBUG: Navigating to active booking: $route');
                      context.push(route);
                      return;
                    }
                    final status = booking.status?.trim();
                    final query = status != null && status.isNotEmpty
                        ? '?status=${Uri.encodeComponent(status)}'
                        : '';
                    final route =
                        '${Routes.sitterBookingDetails}/${booking.applicationId}$query';
                    debugPrint('DEBUG: Navigating to booking details: $route');
                    context.push(route);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error.withValues(alpha: 0.5),
              ),
              AppSpacing.verticalMd,
              Text(
                'Failed to load bookings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              AppSpacing.verticalSm,
              Text(
                error.toString().replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
              AppSpacing.verticalMd,
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(sitterCurrentBookingsProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnButton,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
