import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routing/routes.dart';
import '../../../booking_flow/data/providers/booking_flow_provider.dart';
import '../../../search/models/sitter_list_item_model.dart';
import '../../../../sitters/presentation/saved/saved_sitters_controller.dart';
import '../providers/sitter_profile_providers.dart';
import 'sitter_profile_view.dart';

/// Wrapper page that loads sitter data via Riverpod and renders the profile view.
class SitterProfilePage extends ConsumerWidget {
  final String sitterId;

  const SitterProfilePage({
    super.key,
    required this.sitterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitterAsync = ref.watch(sitterProfileProvider(sitterId));

    // Check bookmark status
    final savedSittersAsync = ref.watch(savedSittersControllerProvider);
    final savedSitters = savedSittersAsync.valueOrNull ?? [];
    // We need to match by sitterId. SitterListItemModel uses `userId` as the sitter ID for bookmarks usually.
    // The `sitterId` passed to this page is likely the `userId` (based on routes).
    // Let's assume `sitterId` == `userId` for bookmarking.
    final isBookmarked = savedSitters.any((s) => s.userId == sitterId);

    return sitterAsync.when(
      loading: () => Scaffold(
        key: const Key('sitterProfilePage'),
        backgroundColor: const Color(0xFFF0F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F9FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Loading...',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        key: const Key('sitterProfilePage'),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(sitterProfileProvider(sitterId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (sitter) => SitterProfileView(
        key: const Key('sitterProfilePage'),
        sitter: sitter,
        isBookmarked: isBookmarked,
        onBookmark: () {
          // Map SitterModel to SitterListItemModel for optimistic update
          final sitterItem = SitterListItemModel(
            id: sitter.id,
            userId: sitter.userId,
            name: sitter.name,
            imageAssetPath: sitter.avatarUrl,
            isVerified: sitter.isVerified,
            rating: sitter.rating,
            reviewCount: sitter.reviewCount,
            distanceText: sitter.distance,
            responseRate: sitter.responseRate, // assuming int matches
            reliabilityRate: sitter.reliabilityRate,
            experienceYears: sitter.experienceYears,
            tags: sitter.badges,
            hourlyRate: sitter.hourlyRate,
          );

          ref.read(savedSittersControllerProvider.notifier).toggleBookmark(
              sitterId,
              isCurrentlySaved: isBookmarked,
              sitterItem: sitterItem);
        },
        onBookPressed: () {
          // Initialize booking flow with sitter data
          ref.read(bookingFlowProvider.notifier).initWithSitter(
                sitterId: sitter.userId,
                sitterName: sitter.name,
                sitterAvatarUrl: sitter.avatarUrl,
                sitterRating: sitter.rating,
                sitterDistance: sitter.distance,
                sitterResponseRate: '${sitter.responseRate}%',
                sitterReliabilityRate: '${sitter.reliabilityRate}%',
                sitterExperience: '${sitter.experienceYears} Years',
                sitterBadges: sitter.badges,
              );
          context.push(Routes.parentBookingStep1);
        },
      ),
    );
  }
}
