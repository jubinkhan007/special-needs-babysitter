import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step6Certification extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step6Certification({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step6Certification> createState() => _Step6CertificationState();
}

class _Step6CertificationState extends ConsumerState<Step6Certification> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = AppColors.primary;

  final List<String> _allCertifications = [
    'CPR Certification',
    'First Aid Certification',
    'Childcare or Babysitting Certification',
    'Special Needs Care Training',
    'Background Check Clearance',
    'Health & Safety Training',
    'Behavioral Management Training',
    'Medication Administration Certification',
  ];

  Future<void> _pickAttachment(String certName) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        // Store the full path for upload, not just the name
        ref
            .read(sitterProfileSetupControllerProvider.notifier)
            .updateCertAttachment(certName, filePath);

        if (mounted) {
          AppToast.show(context, 
            SnackBar(content: Text('Attached: $fileName')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _showCertificationSelector() {
    // Show a modal or dialog to select certifications
    // Since we have MultiSelectAccordion in step 4, we could reuse it or build a simple dialog.
    // The design shows a Dropdown field.
    // I will show a simple MultiSelectDialog.
    showDialog(
      context: context,
      builder: (context) {
        final currentCerts =
            ref.read(sitterProfileSetupControllerProvider).certifications;
        // Local state for the dialog
        List<String> tempSelected = List.from(currentCerts);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Select Certifications',
                style: TextStyle(
                  color: _textDark,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _allCertifications.map((cert) {
                      final isSelected = tempSelected.contains(cert);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: _primaryBlue,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        title: Text(
                          cert,
                          style: const TextStyle(
                            color: _textDark,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 15, // Slightly smaller for list
                          ),
                        ),
                        value: isSelected,
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              tempSelected.add(cert);
                            } else {
                              tempSelected.remove(cert);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(sitterProfileSetupControllerProvider.notifier)
                        .updateCertifications(tempSelected);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: _primaryBlue,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 6,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 6, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.bookmark_border_rounded,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'UPLOAD CERTIFICATIONS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Select Certifications Dropdown (Trigger)
                  GestureDetector(
                    onTap: _showCertificationSelector,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Certifications',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF667085),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF667085)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cert Rows
                  if (state.certifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('No certifications selected.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ...state.certifications.map((cert) {
                    final isAttached = state.certAttachments.containsKey(cert);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              cert,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475467), // Medium grey
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Optional',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3), // Lighter grey
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3, // Give space to attachment button
                            child: GestureDetector(
                              onTap: () => _pickAttachment(cert),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.attach_file,
                                      size: 18,
                                      color: isAttached
                                          ? Colors.green
                                          : _primaryBlue),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      isAttached
                                          ? 'Attached'
                                          : 'Attach Certificate',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isAttached
                                            ? Colors.green
                                            : const Color(
                                                0xFF344054), // Darker text
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Skills Label
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Skills Chips
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: state.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF344054),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100), // Bottom spacing
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: widget.onNext,
          ),
        ),
      ),
    );
  }
}
