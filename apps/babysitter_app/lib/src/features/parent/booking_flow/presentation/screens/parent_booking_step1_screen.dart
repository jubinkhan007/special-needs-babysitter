import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/child_ui_model.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/child_selection_item.dart';
import '../widgets/add_child_button.dart';
import '../widgets/booking_text_area.dart';
import '../widgets/booking_rate_field.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../../../../parent_profile_setup/presentation/widgets/add_child_dialog.dart';
import '../../../account/profile_details/presentation/providers/profile_details_providers.dart';
import '../../../jobs/post_job/presentation/providers/job_post_providers.dart';
import 'parent_booking_step2_screen.dart';

class ParentBookingStep1Screen extends ConsumerStatefulWidget {
  const ParentBookingStep1Screen({super.key});

  @override
  ConsumerState<ParentBookingStep1Screen> createState() =>
      _ParentBookingStep1ScreenState();
}

class _ParentBookingStep1ScreenState
    extends ConsumerState<ParentBookingStep1Screen> {
  String? _selectedChildId;
  String? _selectedChildName;
  final TextEditingController _additionalDetailsController =
      TextEditingController();
  final TextEditingController _payRateController =
      TextEditingController(text: '20');

  // Transportation data from child details
  String? _transportationMode;
  String? _equipmentSafety;
  String? _pickupDropoffDetails;

  @override
  void dispose() {
    _additionalDetailsController.dispose();
    _payRateController.dispose();
    super.dispose();
  }

  void _onChildSelected(String childId, String childName) {
    setState(() {
      _selectedChildId = childId;
      _selectedChildName = childName;
    });

    // Transportation preferences will be populated if Child model has these fields
    // For now, we leave them null as they depend on API schema
  }

  void _onAddChild() {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        onSave: (childData) async {
          final success = await ref
              .read(profileDetailsControllerProvider.notifier)
              .addChild(childData);

          if (success) {
            ref.invalidate(profileDetailsProvider);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to add child')),
              );
            }
          }
        },
      ),
    );
  }

  void _onNext() {
    // Save to provider
    final payRate = double.tryParse(
            _payRateController.text.replaceAll(RegExp(r'[^\d.]'), '')) ??
        0;

    ref.read(bookingFlowProvider.notifier).updateStep1(
          childIds: _selectedChildId != null ? [_selectedChildId!] : [],
          childNames: _selectedChildName != null ? [_selectedChildName!] : [],
          payRate: payRate,
          additionalDetails: _additionalDetailsController.text.isNotEmpty
              ? _additionalDetailsController.text
              : null,
          transportationMode: _transportationMode,
          equipmentSafety: _equipmentSafety,
          pickupDropoffDetails: _pickupDropoffDetails,
        );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ParentBookingStep2Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileDetailsAsync = ref.watch(profileDetailsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: Column(
        children: [
          BookingStepHeader(
            currentStep: 1,
            totalSteps: 4,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () {},
          ),
          Expanded(
            child: profileDetailsAsync.when(
              data: (details) {
                final children = details.children;
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Select a Child',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (children.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No children found. Please add a child.',
                            style: TextStyle(color: Color(0xFF667085)),
                          ),
                        )
                      else
                        ...children.map((child) {
                          final childName =
                              '${child.firstName} ${child.lastName}';
                          return ChildSelectionItem(
                            child: ChildUiModel(
                              id: child.id,
                              name: childName,
                              ageText: '${child.age} Years old',
                              isSelected: _selectedChildId == child.id,
                            ),
                            onTap: () => _onChildSelected(child.id, childName),
                            onEdit: () {},
                          );
                        }),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AddChildButton(onPressed: _onAddChild),
                      ),
                      const SizedBox(height: 24),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE4E7EC),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Additional Details & Pay Rate',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BookingTextArea(
                        hintText: 'Additional Details*',
                        controller: _additionalDetailsController,
                      ),
                      const SizedBox(height: 16),
                      BookingRateField(
                        value: _payRateController.text,
                        onChanged: (val) => _payRateController.text = val,
                      ),
                      SizedBox(
                          height:
                              24 + MediaQuery.of(context).padding.bottom + 60),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          Container(
            color: const Color(0xFFF0F9FF),
            padding: EdgeInsets.fromLTRB(
                24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
            child: BookingPrimaryBottomButton(
              text: 'Next',
              onPressed: _onNext,
            ),
          ),
        ],
      ),
    );
  }
}
