import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import 'package:babysitter_app/src/routing/routes.dart';
import 'presentation/providers/bookings_providers.dart';
import 'presentation/widgets/booking_card.dart';

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
                    color: AppColors.secondary.withOpacity(0.3),
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
                return BookingCard(
                  booking: booking,
                  onTap: () {
                    if (isActive) {
                      context.push(
                          '${Routes.sitterActiveBooking}/${booking.applicationId}');
                      return;
                    }
                    context.push(
                        '${Routes.sitterBookingDetails}/${booking.applicationId}');
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
                color: AppColors.error.withOpacity(0.5),
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
                  foregroundColor: Colors.white,
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
