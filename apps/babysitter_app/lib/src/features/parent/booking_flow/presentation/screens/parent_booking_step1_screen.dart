import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
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
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class ParentBookingStep1Screen extends ConsumerStatefulWidget {
  const ParentBookingStep1Screen({super.key});

  @override
  ConsumerState<ParentBookingStep1Screen> createState() =>
      _ParentBookingStep1ScreenState();
}

class _ParentBookingStep1ScreenState
    extends ConsumerState<ParentBookingStep1Screen> {
  // Support multiple child selection
  final Set<String> _selectedChildIds = {};
  final Map<String, String> _selectedChildNames = {};
  final Map<String, Child> _selectedChildren = {};
  final TextEditingController _additionalDetailsController =
      TextEditingController();
  final TextEditingController _payRateController =
      TextEditingController(text: '20');

  // Validation constants
  static const double _minPayRate = 5.0;
  static const double _maxPayRate = 99.0;

  @override
  void initState() {
    super.initState();
    // Load existing state from provider
    final state = ref.read(bookingFlowProvider);
    _additionalDetailsController.text = state.additionalDetails ?? '';
    if (state.payRate > 0) {
      _payRateController.text = state.payRate.toStringAsFixed(0);
    }
    // Load previously selected children
    if (state.selectedChildIds.isNotEmpty) {
      _selectedChildIds.addAll(state.selectedChildIds);
      for (int i = 0; i < state.selectedChildIds.length; i++) {
        final childId = state.selectedChildIds[i];
        if (i < state.selectedChildNames.length) {
          _selectedChildNames[childId] = state.selectedChildNames[i];
        }
      }
    }
  }

  @override
  void dispose() {
    _additionalDetailsController.dispose();
    _payRateController.dispose();
    super.dispose();
  }

  void _onChildSelected(String childId, String childName, Child child) {
    setState(() {
      if (_selectedChildIds.contains(childId)) {
        // Deselect
        _selectedChildIds.remove(childId);
        _selectedChildNames.remove(childId);
        _selectedChildren.remove(childId);
      } else {
        // Select
        _selectedChildIds.add(childId);
        _selectedChildNames[childId] = childName;
        _selectedChildren[childId] = child;
      }
    });
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
              AppToast.show(context, 
                const SnackBar(content: Text('Failed to add child')),
              );
            }
          }
        },
      ),
    );
  }

  void _onEditChild(Child child) {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        existingChild: child.toMap(),
        onSave: (childData) async {
          final success = await ref
              .read(profileDetailsControllerProvider.notifier)
              .updateChild(child.id, childData);

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

  void _onNext() {
    if (_selectedChildIds.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(
          content: Text('Please select at least one child to continue.'),
        ),
      );
      return;
    }
    
    // Validate pay rate
    final payRate = double.tryParse(
            _payRateController.text.replaceAll(RegExp(r'[^\d.]'), '')) ??
        0;
    
    if (payRate < _minPayRate) {
      AppToast.show(
        context,
        SnackBar(
          content: Text('Pay rate must be at least \$${_minPayRate.toStringAsFixed(0)}'),
        ),
      );
      return;
    }
    
    if (payRate > _maxPayRate) {
      AppToast.show(
        context,
        SnackBar(
          content: Text('Pay rate cannot exceed \$${_maxPayRate.toStringAsFixed(0)}'),
        ),
      );
      return;
    }
    
    // Validate additional details
    if (_additionalDetailsController.text.trim().isEmpty) {
      AppToast.show(
        context,
        const SnackBar(
          content: Text('Please enter additional details.'),
        ),
      );
      return;
    }

    // Build transportation data from all selected children
    final allTransportationModes = <String>{};
    final allEquipmentSafety = <String>{};
    final allPickupLocations = <String>[];
    final allDropoffLocations = <String>[];
    final allSpecialInstructions = <String>[];

    for (final child in _selectedChildren.values) {
      allTransportationModes.addAll(child.transportationModes);
      allEquipmentSafety.addAll(child.equipmentSafety);
      if (child.pickupLocation.isNotEmpty) {
        allPickupLocations.add(child.pickupLocation);
      }
      if (child.dropoffLocation.isNotEmpty) {
        allDropoffLocations.add(child.dropoffLocation);
      }
      if (child.transportSpecialInstructions.isNotEmpty) {
        allSpecialInstructions.add(child.transportSpecialInstructions);
      }
    }

    // Build pickup/dropoff details for display
    final details = <String>[];
    if (allPickupLocations.isNotEmpty) {
      details.add('Pickup: ${allPickupLocations.join(", ")}');
    }
    if (allDropoffLocations.isNotEmpty) {
      details.add('Drop-off: ${allDropoffLocations.join(", ")}');
    }
    if (allSpecialInstructions.isNotEmpty) {
      details.add('Notes: ${allSpecialInstructions.join("; ")}');
    }

    ref.read(bookingFlowProvider.notifier).updateStep1(
          childIds: _selectedChildIds.toList(),
          childNames: _selectedChildIds.map((id) => _selectedChildNames[id] ?? '').toList(),
          payRate: payRate,
          additionalDetails: _additionalDetailsController.text.isNotEmpty
              ? _additionalDetailsController.text
              : null,
          transportationMode: allTransportationModes.isNotEmpty
              ? allTransportationModes.join(', ')
              : null,
          equipmentSafety: allEquipmentSafety.isNotEmpty
              ? allEquipmentSafety.join(', ')
              : null,
          pickupDropoffDetails: details.isNotEmpty ? details.join('\n') : null,
          pickupLocation: allPickupLocations.isNotEmpty ? allPickupLocations.join(', ') : null,
          dropoffLocation: allDropoffLocations.isNotEmpty ? allDropoffLocations.join(', ') : null,
          transportSpecialInstructions: allSpecialInstructions.isNotEmpty
              ? allSpecialInstructions.join('; ')
              : null,
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
      backgroundColor: AppColors.surfaceTint,
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
                        'Select Children',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You can select multiple children for this booking',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
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
                              isSelected: _selectedChildIds.contains(child.id),
                            ),
                            onTap: () =>
                                _onChildSelected(child.id, childName, child),
                            onEdit: () => _onEditChild(child),
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
              error: (err, stack) {
                debugPrint('ERROR: ParentBookingStep1Screen error: $err');
                debugPrint('DEBUG: Stack trace: $stack');
                return Center(child: Text('Error: $err'));
              },
            ),
          ),
          Container(
            color: AppColors.surfaceTint,
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
