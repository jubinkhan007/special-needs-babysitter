import 'package:flutter/material.dart';
import '../../data/models/child_ui_model.dart';
import '../../data/models/booking_step1_ui_model.dart';
import '../../data/mock/booking_step1_mock_data.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/child_selection_item.dart';
import '../widgets/add_child_button.dart';
import '../widgets/booking_text_area.dart';
import '../widgets/booking_rate_field.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../../../../parent_profile_setup/presentation/widgets/add_child_dialog.dart'; // Import Dialog
import 'parent_booking_step2_screen.dart';

class ParentBookingStep1Screen extends StatefulWidget {
  const ParentBookingStep1Screen({super.key});

  @override
  State<ParentBookingStep1Screen> createState() =>
      _ParentBookingStep1ScreenState();
}

class _ParentBookingStep1ScreenState extends State<ParentBookingStep1Screen> {
  // Simulating state for now. In real app, use Riverpod.
  late BookingStep1UiModel _uiModel;

  @override
  void initState() {
    super.initState();
    _uiModel = BookingStep1MockData.initialData;
  }

  void _onChildSelected(String childId) {
    setState(() {
      final updatedChildren = _uiModel.children.map((child) {
        return child.copyWith(isSelected: child.id == childId);
      }).toList();
      _uiModel = _uiModel.copyWith(children: updatedChildren);
    });
  }

  void _onAddChild() {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        onSave: (childData) {
          // Convert Map to ChildUiModel
          final newChild = ChildUiModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: '${childData['firstName']} ${childData['lastName']}',
            ageText: '${childData['age']} Years old',
            isSelected: true, // Auto-select new child?
          );

          setState(() {
            // Add new child and update selection
            // Deselect others if single selection
            final updatedChildren = [
              ..._uiModel.children.map((c) => c.copyWith(isSelected: false)),
              newChild
            ];
            _uiModel = _uiModel.copyWith(children: updatedChildren);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F9FF), // A) Light blue background #F0F9FF
      body: Column(
        children: [
          // Header (Handles its own top safe area)
          BookingStepHeader(
            currentStep: 1,
            totalSteps: 4,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              physics:
                  const ClampingScrollPhysics(), // Matches iOS feel usually
              padding:
                  EdgeInsets.symmetric(horizontal: 24), // Matches Figma padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      height: 24), // D) Vertical spacing progress -> title

                  // D) Title: Select a Child
                  const Text(
                    'Select a Child',
                    style: TextStyle(
                      fontSize: 20, // Match Figma
                      fontWeight: FontWeight.w700, // Bold
                      color: Color(0xFF101828), // Near black
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // E) Child List
                  ..._uiModel.children.map((child) => ChildSelectionItem(
                        child: child,
                        onTap: () => _onChildSelected(child.id),
                        onEdit: () {},
                      )),

                  const SizedBox(height: 16),

                  // F) Add Child Button: Left aligned, Pill-ish
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AddChildButton(onPressed: _onAddChild),
                  ),

                  const SizedBox(height: 24), // Spacing before divider

                  // G) Section Divider
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE4E7EC), // Light grey
                  ),

                  const SizedBox(height: 24), // Spacing after divider

                  // H) Title: Additional Details & Pay Rate
                  const Text(
                    'Additional Details & Pay Rate',
                    style: TextStyle(
                      fontSize: 20, // Larger and bolder per checklist
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // I) Text Area
                  const BookingTextArea(hintText: 'Additional Details*'),

                  const SizedBox(height: 16),

                  // J) Pay Rate
                  BookingRateField(value: _uiModel.payRateText),

                  // Bottom spacing so content doesn't hide behind sticky button
                  SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom + 60),
                ],
              ),
            ),
          ),

          // K) Bottom Sticky Button
          Container(
            color: const Color(
                0xFFF0F9FF), // Match background (or transparent if over white?) - Figma shows screen bg is blue
            padding: EdgeInsets.fromLTRB(
                24,
                0, // Top padding handled by content spacing or minimal
                24,
                MediaQuery.of(context).padding.bottom + 16),
            child: BookingPrimaryBottomButton(
              text: 'Next',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentBookingStep2Screen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
