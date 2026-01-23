import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'controllers/sitter_profile_details_controller.dart';
import 'widgets/profile_photo_section.dart';
import 'widgets/skills_certifications_section.dart';
import 'widgets/availability_section.dart';
import 'widgets/hourly_rate_section.dart';
import 'widgets/professional_info_section.dart';
import 'widgets/edit_professional_info_dialog.dart';

class SitterProfileDetailsScreen extends ConsumerWidget {
  const SitterProfileDetailsScreen({super.key});

  static const Color _backgroundBlue = Color(0xFFF7F9FC);
  static const Color _textGray = Color(0xFF667085);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(sitterProfileDetailsControllerProvider);

    return Scaffold(
      backgroundColor: _backgroundBlue,
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(
            color: _textGray,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _backgroundBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textGray),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: _textGray),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(sitterProfileDetailsControllerProvider.notifier).refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Photo
                  ProfilePhotoSection(
                    photoUrl: profile.photoUrl,
                    onEditTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit photo coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Skills & Certifications
                  SkillsCertificationsSection(
                    certifications: profile.certifications,
                    yearsOfExperience: profile.yearsOfExperience,
                    ageRanges: profile.ageRanges,
                    onEditTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit skills coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  AvailabilitySection(
                    availability: profile.availability,
                  ),
                  const SizedBox(height: 16),

                  // Hourly Rate
                  HourlyRateSection(
                    hourlyRate: profile.hourlyRate,
                    openToNegotiating: profile.openToNegotiating,
                    onEditTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit rate coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Professional Information
                  ProfessionalInfoSection(
                    bio: profile.bio,
                    skills: profile.skills,
                    languages: profile.languages,
                    hasTransportation: profile.hasTransportation,
                    transportationDetails: profile.transportationDetails,
                    willingToTravel: profile.willingToTravel,
                    onEditTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfessionalInfoDialog(
                          profile: profile,
                          onSave: (payload) async {
                            final success = await ref
                                .read(sitterProfileDetailsControllerProvider.notifier)
                                .updateProfessionalInfo(payload);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Profile updated successfully'
                                      : 'Failed to update profile'),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final appError = AppErrorHandler.parse(err);
          return GlobalErrorWidget(
            title: appError.title,
            message: appError.message,
            onRetry: () {
              ref.invalidate(sitterProfileDetailsControllerProvider);
            },
          );
        },
      ),
    );
  }
}
