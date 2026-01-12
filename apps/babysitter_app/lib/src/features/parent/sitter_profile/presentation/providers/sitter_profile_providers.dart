import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';

/// Provider for loading a sitter profile by ID.
/// Returns AsyncValue<SitterModel> for loading/error/success states.
final sitterProfileProvider =
    FutureProvider.family<SitterModel, String>((ref, sitterId) async {
  // TODO: Replace with actual API call
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 800));

  // Return mock data for now
  // In production, this would fetch from sitter profile API
  return SitterModel(
    id: sitterId,
    name: 'Krystina',
    bio:
        "Hi! I'm Krystina, a dedicated babysitter with 5+ years of experience, including working with children on the autism spectrum. I focus on creating safe, fun, and structured environments.",
    avatarUrl: 'assets/images/avatars/avatar_krystina.png',
    rating: 4.5,
    location: '2 Miles Away',
    distance: '2 Miles',
    responseRate: 95,
    reliabilityRate: 95,
    experienceYears: 5,
    hourlyRate: 20.0,
    isVerified: true,
    badges: ['CPR', 'First-aid', 'Special Needs Training'],
  );
});

/// Provider for toggling favorite/bookmark state.
final sitterBookmarkProvider =
    StateProvider.family<bool, String>((ref, sitterId) {
  return false; // Default not bookmarked
});
