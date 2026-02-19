import 'package:core/core.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'providers/profile_details_providers.dart';
import 'profile_details_ui_constants.dart';
import 'widgets/profile_details_info_card.dart';
import 'widgets/child_list_card.dart';
import 'widgets/emergency_contact_card.dart';
import 'widgets/insurance_plan_card.dart';
import 'widgets/edit_profile_details_dialog.dart';
import 'widgets/edit_emergency_contact_dialog.dart';
import 'widgets/edit_insurance_plan_dialog.dart';
import '../../../../parent_profile_setup/presentation/widgets/add_child_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ConsumerState<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final stateForLoad = ref.watch(profileDetailsControllerProvider);

    return Scaffold(
      backgroundColor: ProfileDetailsUI.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(
            color: AppColors.buttonDark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: ProfileDetailsUI.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 1, // Subtle shadow on scroll
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.buttonDark),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF6B7280)),
            onPressed: () {
              // Notification action
            },
          ),
        ],
      ),
      body: stateForLoad.when(
        data: (state) {
          if (state.isLoading && state.details == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.details == null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          final details = state.details;
          if (details == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: ProfileDetailsUI.screenPadding,
              vertical: 24,
            ),
            child: Column(
              children: [
                ProfileDetailsInfoCard(
                  details: details,
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditProfileDetailsDialog(
                        initialDetails: details,
                        onSave: (data) async {
                          final success = await ref
                              .read(profileDetailsControllerProvider.notifier)
                              .updateYourDetails(data);

                          if (success && context.mounted) {
                            // Dialog closes itself on check in internal save, but we can double check
                            // Actually dialog handles save + pop. We just provide boolean logic.
                            // The dialog calls this function, awaits it.
                          }
                        },
                        onUploadPhoto: (file) => ref
                            .read(profileDetailsControllerProvider.notifier)
                            .uploadPhoto(file),
                      ),
                    );
                  },
                  onEditAvatar: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile == null) return;

                    final file = File(pickedFile.path);
                    String? photoUrl;

                    try {
                      photoUrl = await ref
                          .read(profileDetailsControllerProvider.notifier)
                          .uploadPhoto(file);
                    } catch (e) {
                      if (context.mounted) {
                        AppToast.show(context,
                            SnackBar(content: Text('Error uploading photo: $e')));
                      }
                      return;
                    }

                    if (photoUrl.isEmpty) {
                      if (context.mounted) {
                        AppToast.show(context,
                            const SnackBar(content: Text('Upload failed.')));
                      }
                      return;
                    }

                    final payload = <String, dynamic>{
                      'photoUrl': photoUrl,
                      'familyName': details.familyName,
                      'numberOfFamilyMembers': details.numberOfFamilyMembers,
                      'familyBio': details.familyBio,
                      'hasPets': details.hasPets,
                      'numberOfPets': details.numberOfPets,
                      'petTypes': details.petTypes,
                      'speaksOtherLanguages': details.speaksOtherLanguages,
                      'numberOfLanguages': details.speaksOtherLanguages
                          ? details.languages.length
                          : 0,
                      'languages': details.languages,
                    };

                    final success = await ref
                        .read(profileDetailsControllerProvider.notifier)
                        .updateYourDetails(payload, step: 1);

                    if (context.mounted) {
                      AppToast.show(
                        context,
                        SnackBar(
                          content: Text(success
                              ? 'Profile photo updated'
                              : 'Failed to update profile photo'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: ProfileDetailsUI.cardSpacing),

                ChildListCard(
                  children: details.children,
                  onAddChild: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddChildDialog(
                        onSave: (childData) async {
                          final success = await ref
                              .read(profileDetailsControllerProvider.notifier)
                              .addChild(childData);

                          if (success && context.mounted) {
                            // Optionally show success snackbar
                          }
                        },
                      ),
                    );
                  },
                  onEditChild: (childId) {
                    final child =
                        details.children.firstWhere((c) => c.id == childId);
                    showDialog(
                      context: context,
                      builder: (context) => AddChildDialog(
                        existingChild: child.toMap(),
                        onSave: (childData) async {
                          final success = await ref
                              .read(profileDetailsControllerProvider.notifier)
                              .updateChild(childId, childData);

                          if (success && context.mounted) {
                            // Optionally show success snackbar
                          }
                        },
                      ),
                    );
                  },
                  onDeleteChild: (childId) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Delete child?'),
                        content: const Text(
                            'This will permanently remove this child.'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed != true) return;

                    final success = await ref
                        .read(profileDetailsControllerProvider.notifier)
                        .deleteChild(childId);

                    if (context.mounted) {
                      AppToast.show(
                        context,
                        SnackBar(
                          content: Text(success
                              ? 'Child deleted'
                              : 'Failed to delete child'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: ProfileDetailsUI.cardSpacing),

                // CareApproachCard removed as per user request

                EmergencyContactCard(
                  contact: details.emergencyContact,
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditEmergencyContactDialog(
                        initialContact: details.emergencyContact,
                        onSave: (data) async {
                          // Update using the same 'updateProfileDetails' logic but nested
                          // Since API likely expects { "emergencyContact": { ... } } for partial update
                          // assuming we merge this into the main payload.
                          // Actually updateYourDetails takes map. Let's wrap it.
                          final success = await ref
                              .read(profileDetailsControllerProvider.notifier)
                              .updateYourDetails({'emergencyContact': data},
                                  step: 3);

                          if (success && context.mounted) {
                            // Success handling
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: ProfileDetailsUI.cardSpacing),

                InsurancePlanCard(
                  plan: details.insurancePlan,
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditInsurancePlanDialog(
                        initialPlan: details.insurancePlan,
                        onSave: (data) async {
                          final success = await ref
                              .read(profileDetailsControllerProvider.notifier)
                              .updateYourDetails({
                            'insurancePlans': [data]
                          }, step: 3);

                          if (success && context.mounted) {
                            // Success handling
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32), // Bottom padding
              ],
            ),
          );
        },
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
