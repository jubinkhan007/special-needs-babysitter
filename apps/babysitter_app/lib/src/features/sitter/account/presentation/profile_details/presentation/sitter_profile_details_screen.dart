import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:image_picker/image_picker.dart';

import 'controllers/sitter_profile_details_controller.dart';
import 'widgets/profile_photo_section.dart';
import 'widgets/skills_certifications_section.dart';
import 'widgets/availability_section.dart';
import 'widgets/hourly_rate_section.dart';
import 'widgets/professional_info_section.dart';
import 'widgets/edit_professional_info_dialog.dart';
import 'widgets/edit_skills_certifications_dialog.dart';
import 'widgets/edit_hourly_rate_dialog.dart';
import 'widgets/edit_availability_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

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
                      _pickAndUploadPhoto(context, ref);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Skills & Certifications
                  SkillsCertificationsSection(
                    certifications: profile.certifications,
                    yearsOfExperience: profile.yearsOfExperience,
                    ageRanges: profile.ageRanges,
                    onEditTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditSkillsCertificationsDialog(
                          initialSkills: profile.skills ?? [],
                          initialCertifications: profile.certifications
                                  ?.map((cert) => cert.type)
                                  .toList() ??
                              [],
                          initialAgeRanges: profile.ageRanges ?? [],
                          initialYearsOfExperience: profile.yearsOfExperience,
                          onSave: (payload) async {
                            final success = await ref
                                .read(
                                    sitterProfileDetailsControllerProvider.notifier)
                                .updateSkillsAndCertifications(
                                  profile: profile,
                                  skills: payload.skills,
                                  certifications: payload.certifications,
                                  ageRanges: payload.ageRanges,
                                  yearsOfExperience: payload.yearsOfExperience,
                                );
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(success
                                      ? 'Profile updated successfully'
                                      : 'Failed to update profile'),
                                ),
                              );
                            }
                            return success;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  AvailabilitySection(
                    availability: profile.availability,
                    onEditTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditAvailabilityDialog(
                          initialAvailability: profile.availability,
                          onSave: (availability) async {
                            final success = await ref
                                .read(
                                    sitterProfileDetailsControllerProvider.notifier)
                                .updateAvailability(availability);
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(success
                                      ? 'Availability updated successfully'
                                      : 'Failed to update availability'),
                                ),
                              );
                            }
                            return success;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Hourly Rate
                  HourlyRateSection(
                    hourlyRate: profile.hourlyRate,
                    openToNegotiating: profile.openToNegotiating,
                    onEditTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditHourlyRateDialog(
                          initialRate: profile.hourlyRate ?? 15.0,
                          initialOpenToNegotiating:
                              profile.openToNegotiating ?? false,
                          onSave: (rate, openToNegotiating) async {
                            final success = await ref
                                .read(
                                    sitterProfileDetailsControllerProvider.notifier)
                                .updateHourlyRate(
                                  hourlyRate: rate,
                                  openToNegotiating: openToNegotiating,
                                );
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(success
                                      ? 'Hourly rate updated successfully'
                                      : 'Failed to update hourly rate'),
                                ),
                              );
                            }
                            return success;
                          },
                        ),
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
                              AppToast.show(context, 
                                SnackBar(
                                  content: Text(success
                                      ? 'Profile updated successfully'
                                      : 'Failed to update profile'),
                                ),
                              );
                            }
                            return success;
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

  Future<void> _pickAndUploadPhoto(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final success = await ref
        .read(sitterProfileDetailsControllerProvider.notifier)
        .updateProfilePhoto(File(pickedFile.path));

    if (context.mounted) {
      AppToast.show(
        context,
        SnackBar(
          content: Text(success
              ? 'Profile photo updated successfully'
              : 'Failed to update profile photo'),
        ),
      );
    }
  }
}
