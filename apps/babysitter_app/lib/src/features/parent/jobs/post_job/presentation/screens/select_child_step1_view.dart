import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/job_post_providers.dart';
import '../controllers/job_post_controller.dart';
import 'package:domain/domain.dart';
import '../../../../../parent_profile_setup/presentation/widgets/add_child_dialog.dart';
import '../../../../account/profile_details/presentation/providers/profile_details_providers.dart';
import 'job_post_step_header.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Step 1: Select a Child for Job Posting
/// Pixel-perfect implementation matching Figma design
class SelectChildStep1View extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SelectChildStep1View({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<SelectChildStep1View> createState() =>
      _SelectChildStep1ViewState();
}

class _SelectChildStep1ViewState extends ConsumerState<SelectChildStep1View> {
  // Selected child IDs
  final Set<String> _selectedChildIds = {};

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing state (if any)
    final currentIds = ref.read(jobPostControllerProvider).childIds;
    _selectedChildIds.addAll(currentIds);
  }

  // Design Constants
  static const _bgColor = AppColors.surfaceTint; // Very light blue background
  static const _primaryBlue = AppColors.primary; // Light blue for buttons
  static const _darkNavy = Color(0xFF1A1A1A); // Near-black text
  static const _grayText = Color(0xFF667085); // Gray text

  static const _dividerColor = Color(0xFFE4E7EC); // Light gray divider
  static const _addButtonColor = Color(0xFF101828); // Dark button color

  void _toggleChild(String childId) {
    setState(() {
      if (_selectedChildIds.contains(childId)) {
        _selectedChildIds.remove(childId);
      } else {
        _selectedChildIds.add(childId);
      }
    });
  }

  void _onEditChild(Child child) {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        existingChild: child.toMap(),
        onSave: (data) async {
          final success = await ref
              .read(profileDetailsControllerProvider.notifier)
              .updateChild(child.id, data);

          if (success) {
            ref.invalidate(profileDetailsProvider);
          } else {
            if (context.mounted) {
              AppToast.show(context, 
                const SnackBar(content: Text('Failed to update child')),
              );
            }
          }
        },
      ),
    );
  }

  void _onAddChild() {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        onSave: (data) async {
          final success = await ref
              .read(profileDetailsControllerProvider.notifier)
              .addChild(data);

          if (success) {
            // Data will auto-refresh due to stream/future provider dependency if set up correctly
            // The profileDetailsProvider should be linked to the controller or vice versa?
            // Actually profileDetailsProvider is a FutureProvider.
            // But profileDetailsControllerProvider updates its state.
            // We should invalidate profileDetailsProvider to re-fetch
            ref.invalidate(profileDetailsProvider);
          } else {
            if (context.mounted) {
              AppToast.show(context, 
                const SnackBar(content: Text('Failed to add child')),
              );
            }
          }
        },
      ),
    );
  }

  void _onContinue() {
    if (_selectedChildIds.isNotEmpty) {
      // Update controller state
      ref
          .read(jobPostControllerProvider.notifier)
          .updateChildIds(_selectedChildIds.toList());
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobPostState>(jobPostControllerProvider, (previous, next) {
      if (previous?.childIds != next.childIds) {
        setState(() {
          _selectedChildIds.clear();
          _selectedChildIds.addAll(next.childIds);
        });
      }
    });

    final profileDetailsAsync = ref.watch(profileDetailsProvider);

    return profileDetailsAsync.when(
      data: (details) {
        final children = details.children;
        final isEnabled = _selectedChildIds.isNotEmpty;

        return Scaffold(
          backgroundColor: _bgColor,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                JobPostStepHeader(
                  activeStep: 1,
                  totalSteps: 5,
                  onBack: widget.onBack,
                ),

                // Main Content (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildIconCard(),
                        const SizedBox(height: 20),
                        const Text(
                          'Select a Child',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _darkNavy,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Children List
                        if (children.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No children found. Please add a child to post a job.',
                              style: TextStyle(color: _grayText),
                            ),
                          )
                        else
                          ...children.map((child) => _buildChildRow(child)),

                        const SizedBox(height: 16),
                        _buildAddChildButton(),
                        const SizedBox(height: 24),
                        Container(
                          height: 1,
                          color: _dividerColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Continue Button
                _buildContinueButton(isEnabled),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) {
        print('ERROR: SelectChildStep1View error: $err');
        print('DEBUG: Stack trace: $stack');
        return Scaffold(
          body: Center(child: Text('Error: $err')),
        );
      },
    );
  }

  Widget _buildIconCard() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surfaceTint, // Soft blue fill
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.family_restroom_outlined, // Caretaker/child style icon
          size: 36,
          color: _primaryBlue,
        ),
      ),
    );
  }

  Widget _buildChildRow(Child child) {
    final isSelected = _selectedChildIds.contains(child.id);

    // Calculate age label
    final ageLabel = '${child.age} Years old'; // Simple mapping for now

    return GestureDetector(
      onTap: () => _toggleChild(child.id),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => _toggleChild(child.id),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? _primaryBlue : const Color(0xFFD0D5DD),
                    width: 1.5,
                  ),
                  color: isSelected ? _primaryBlue : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Name and Age
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${child.firstName} ${child.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _darkNavy,
                      ),
                    ),
                    TextSpan(
                      text: '  ($ageLabel)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _grayText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Edit Icon
            GestureDetector(
              onTap: () => _onEditChild(child),
              child: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: _grayText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildButton() {
    return GestureDetector(
      onTap: _onAddChild,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _addButtonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Add Child',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: isEnabled ? _onContinue : null,
          child: Container(
            width: 160,
            height: 52,
            decoration: BoxDecoration(
              color: _primaryBlue.withOpacity(isEnabled ? 1.0 : 0.5),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Center(
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
