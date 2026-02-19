import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step5Experience extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Experience({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step5Experience> createState() => _Step5ExperienceState();
}

class _Step5ExperienceState extends ConsumerState<Step5Experience> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = AppColors.primary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(sitterProfileSetupControllerProvider);
      if (state.experiences.isEmpty) {
        ref.read(sitterProfileSetupControllerProvider.notifier).addExperience(
              const Experience(),
            );
      }
    });
  }

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        // Store the full path for upload, not just the name
        ref
            .read(sitterProfileSetupControllerProvider.notifier)
            .updateResumePath(filePath);

        if (mounted) {
          AppToast.show(context, 
            SnackBar(content: Text('Resume uploaded: $fileName')),
          );
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final controller = ref.read(sitterProfileSetupControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 5,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 5, totalSteps: kSitterProfileTotalSteps),
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
                    child: const Icon(Icons.star_border_rounded,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Experience',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload Resume Section
                  const Text(
                    'Upload Resume',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickResume,
                    icon: Icon(Icons.note_add_outlined,
                        color: _textDark.withOpacity(0.8)),
                    label: Text(
                      state.resumePath != null
                          ? 'Resume Uploaded (${state.resumePath})'
                          : 'Upload Resume',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _textDark.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                          color: Color(0xFFD0D5DD)), // Grey border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PDF or Word documents only',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textDark.withOpacity(0.5),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Manually Add Experience Label
                  const Text(
                    'Manually Add Experience',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Experience Forms List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.experiences.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final exp = state.experiences[index];
                      return _ExperienceForm(
                        experience: exp,
                        onUpdate: (updatedExp) {
                          controller.updateExperience(index, updatedExp);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Add Another Experience Button
                  OutlinedButton.icon(
                    onPressed: () {
                      controller.addExperience(const Experience());
                    },
                    icon: const Icon(Icons.add, color: _textDark),
                    label: const Text(
                      'Add Another Experience',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppColors.surfaceTint,
                      side: const BorderSide(
                          color:
                              AppColors.surfaceTint), // Matches fill for flat look
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Skip Button
              OutlinedButton(
                onPressed: () {
                  widget.onNext(); // Skip logic same as next for now
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFFD0D5DD)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44), // Pill shape
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Continue Button
              PrimaryActionButton(
                label: 'Continue',
                onPressed: widget.onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceForm extends StatelessWidget {
  final Experience experience;
  final ValueChanged<Experience> onUpdate;

  const _ExperienceForm({
    required this.experience,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role / Title
        _buildTextField(
          hint: 'Past Role / Title',
          value: experience.title,
          onChanged: (val) => onUpdate(Experience(
            title: val,
            month: experience.month,
            year: experience.year,
            description: experience.description,
          )),
        ),
        const SizedBox(height: 12),

        // Month / Year Row
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                hint: 'Month',
                value: experience.month.isNotEmpty ? experience.month : null,
                items: [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec'
                ],
                onChanged: (val) {
                  if (val != null) {
                    onUpdate(Experience(
                      title: experience.title,
                      month: val,
                      year: experience.year,
                      description: experience.description,
                    ));
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                hint: 'Year',
                value: experience.year.isNotEmpty ? experience.year : null,
                items: List.generate(20, (index) => (2025 - index).toString()),
                onChanged: (val) {
                  if (val != null) {
                    onUpdate(Experience(
                      title: experience.title,
                      month: experience.month,
                      year: val,
                      description: experience.description,
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Description
        Container(
          height: 120, // Taller for description
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(text: experience.description)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: experience.description.length)),
            onChanged: (val) => onUpdate(Experience(
              title: experience.title,
              month: experience.month,
              year: experience.year,
              description: val,
            )),
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Description',
              hintStyle: TextStyle(color: Color(0xFF98A2B3)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              // FIX: Transparent background
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      // FIX: Removed padding from Container to eliminate extra left margin
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection =
              TextSelection.fromPosition(TextPosition(offset: value.length)),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
          // FIX: Transparent background
          filled: true,
          fillColor: Colors.transparent,
          // FIX: Added contentPadding here to control internal spacing properly
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1A1A1A),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF98A2B3))),
          value: value,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF98A2B3)),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
