import '../../domain/entities/sitter_job_details.dart';

/// Mock data source for sitter job details.
class SitterJobDetailsMockSource {
  /// Returns mock job details for development/testing.
  Future<SitterJobDetails> getJobDetails(String jobId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return const SitterJobDetails(
      id: '1',
      title: 'Part Time Sitter Needed',
      postedTimeAgo: 'Job posted 1 hour ago',
      isBookmarked: false,
      familyName: 'The Smith Family',
      familyAvatarUrl: null,
      childrenCount: 2,
      children: [
        JobChildInfo(name: 'Ally', age: 4),
        JobChildInfo(name: 'Jason', age: 2),
      ],
      location: 'Brooklyn, NY 11201',
      distance: '7.35 km away',
      dateRange: '14 Aug - 17 Aug',
      timeRange: '09 AM - 06 PM',
      personality: 'Energetic, Playful and Lovers Outdoor',
      allergies: 'None',
      triggers: 'Loud noises and sudden changes in routine',
      calmingMethods: 'Reading books, Playing quiet games',
      additionalNotes: 'We Have Two Black Cats',
      transportationModes: [
        'No transportation (care at home only)',
        'Walking only (short distance)',
        'Family vehicle with car seat provided',
        'Ride-share allowed (with parent consent)',
      ],
      equipmentSafety: [
        'Car seat required',
        'Booster seat required',
      ],
      pickupDropoffDetails: [
        'Sunshine Elementary School, Gate 3',
        'Home — 42 Greenview Avenue, Apt 5B',
        'Pick up at the school gate only. Please avoid using highways as my child gets motion sickness.',
      ],
      requiredSkills: ['CPR', 'First-aid', 'Special Needs Training'],
      hourlyRate: 20,
    );
  }
}
