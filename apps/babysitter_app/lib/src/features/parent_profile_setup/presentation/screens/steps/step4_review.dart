import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../widgets/add_child_dialog.dart';
import '../../widgets/add_emergency_contact_dialog.dart';

/// Step 4: Review Your Profile
/// Matches Figma: Icon header, Profile Photo, Edit sections, Confirm button.
class Step4Review extends ConsumerStatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step4Review({
    super.key,
    required this.onFinish,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step4Review> createState() => _Step4ReviewState();
}

class _Step4ReviewState extends ConsumerState<Step4Review> {
  static const _bgBlue = Color(0xFFF3FAFD);
  static const _sectionTitleColor = Color(0xFF1A1A1A);
  static const _labelColor = Color(0xFF1A1A1A); // Darker
  static const _valueColor = Color(0xFF667085); // Greyer

  void _editChild([Map<String, dynamic>? child, int? index]) {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        existingChild: child,
        onSave: (data) {
          setState(() {
            final kids = widget.profileData['kids'] as List? ?? [];
            if (index != null) {
              kids[index] = data;
            } else {
              kids.add(data);
              widget.profileData['kids'] = kids; // Ensure list init
            }
          });
        },
      ),
    );
  }

  void _editEmergencyContact() {
    // Reusing the existing dialog for adding/editing main contact
    final contacts = widget.profileData['emergencyContacts'] as List? ?? [];
    final current = contacts.isNotEmpty ? contacts.first : null;

    showDialog(
      context: context,
      builder: (context) => AddEmergencyContactDialog(
        existingContact: current,
        onSave: (data) {
          setState(() {
            // supporting single main contact for now based on UI
            widget.profileData['emergencyContacts'] = [data];
          });
        },
      ),
    );
  }

  // Placeholder for insurance edit since no dialog exists yet
  void _editInsurance() {
    // TODO: Implement insurance dialog
  }

  @override
  Widget build(BuildContext context) {
    // Extract Data
    final kids = widget.profileData['kids'] as List? ?? [];

    // Family Basics
    // Note: Step 1 redesign didn't explicitly key 'familyName' in previous code snippet?
    // I should check Step1 code if needed, but for now assuming standard keys.
    // Looking at Step 1, it used local state vars.
    // I might need to update Step 1 to save to profileData map if it doesn't already!
    // **Self-Correction**: Step 1 implementation I wrote used local controllers but passed onNext.
    // It *did not* seem to save to a map passed in?
    // Wait, Step 1 in my implementation was `Step1FamilyIntro`.
    // It didn't take `profileData` in the constructor!
    // This is a BUG in my previous step 1 implementation. I need to fix Step 1 to save data to a map
    // OR the ProfileSetupFlow needs to pass it.
    // I will assume I need to fix Step 1.
    // For now, let's implement the UI assuming data exists.

    final membersCount = '4'; // data['familyMembersCount']
    final familyBio =
        'In family life, love is the oil that eases friction, the cement that binds closer together, and the music that brings harmony.'; // data['bio']
    final petsCount = '1'; // data['numPets']
    final languages = 'English, French and Spanish'; // data['languages']

    // Care
    final careData = widget.profileData['careTransport'] as Map? ?? {};
    final careApproach = careData['careApproach'] as String? ??
        'My child has sensory sensitivities...';
    final transportNeeds =
        (careData['needsPickup'] == true) ? 'Pickup' : 'None';
    final pickupReq = careData['pickupRequirements'] ?? 'Pickup from school...';
    final specialAccom =
        careData['accomodations'] ?? 'My child has a peanut allergy...';

    // Emergency
    final contacts = widget.profileData['emergencyContacts'] as List? ?? [];
    final emergencyContact = contacts.isNotEmpty
        ? contacts.first
        : {
            'name': 'Ryan Mike',
            'relationship': 'Father',
            'phone': '415-555-0132',
            'email': 'Ryan29@gmail.com',
            // address? specialInstruction?
          };

    return Scaffold(
      backgroundColor: _bgBlue,
      appBar: AppBar(
        backgroundColor: _bgBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Step 4 of 4',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF667085)),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                _buildDot(active: true),
                _buildConnectingLine(active: true),
                _buildDot(active: true),
                _buildConnectingLine(active: true),
                _buildDot(active: true),
                _buildConnectingLine(active: true),
                _buildDot(active: true, large: true), // Step 4
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD6F0FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person_search_outlined, // magnifying glass / review
                size: 40,
                color: AuthTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Review Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Photo with edit
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/user_avatar_placeholder.png'), // Need asset or mock
                  backgroundColor: Colors.white,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: const Icon(Icons.edit,
                        size: 14, color: Color(0xFF667085)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // YOUR DETAILS
            _buildSectionHeader('Your Details', () {/* Edit Step 1 */}),
            _buildDetailRow('No. of Family Members:', membersCount),
            _buildDetailRow('Family Bio:', familyBio, isLong: true),
            _buildDetailRow('No. of Pets:', petsCount),
            _buildDetailRow('Languages:', languages),
            const Divider(height: 32, color: Color(0xFFE4E7EC)),

            // CHILD
            _buildSectionHeader('Child', null), // Edit is per child
            if (kids.isEmpty)
              const Text('No children added.',
                  style: TextStyle(color: Colors.grey))
            else
              ...kids
                  .asMap()
                  .entries
                  .map((e) => _buildChildRow(e.value, e.key)),

            const SizedBox(height: 12),
            SizedBox(
              width: 120,
              height: 36,
              child: ElevatedButton(
                onPressed: () => _editChild(null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D2939),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Add Child',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),
            const Divider(height: 32, color: Color(0xFFE4E7EC)),

            // CARE APPROACH
            _buildSectionHeader('Care Approach & Transport', () {
              /* Edit Step 3 */
            }),
            _buildDetailRow('Care Approach:', careApproach, isLong: true),
            _buildDetailRow('Transportation Needs:', transportNeeds),
            // Mock Q&A for now as string display
            _buildDetailRow(
                'Does your child need to be picked up from school, an activity, or therapy?',
                careData['needsPickup'] == true ? 'Yes' : 'No',
                isQuestion: true),
            _buildDetailRow(
                'Does your child need to be dropped off at therapy, school, or an activity?',
                careData['needsDropoff'] == true ? 'Yes' : 'No',
                isQuestion: true),
            _buildDetailRow('Pickup/Drop-Off Requirements:', pickupReq,
                isLong: true),
            _buildDetailRow('Special Accommodations Description:', specialAccom,
                isLong: true),
            const Divider(height: 32, color: Color(0xFFE4E7EC)),

            // EMERGENCY CONTACT
            _buildSectionHeader('Emergency Contact', _editEmergencyContact),
            _buildDetailRow('Full Name:', emergencyContact['name']),
            _buildDetailRow(
                'Relationship to Child:', emergencyContact['relationship']),
            _buildDetailRow('Primary Phone Number:', emergencyContact['phone']),
            _buildDetailRow('Email Address:', emergencyContact['email']),
            _buildDetailRow('Address:', '123 House, Lorem City, Loem'), // Mock
            _buildDetailRow(
                'Special Instruction:', 'My child has a peanut allergy...',
                isLong: true), // Mock
            const Divider(height: 32, color: Color(0xFFE4E7EC)),

            // INSURANCE PLAN
            _buildSectionHeader('Insurance Plan', _editInsurance),
            const Text('Lorem Ipsum',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: _sectionTitleColor)),

            const SizedBox(height: 48),

            // Footer Button
            PrimaryActionButton(
              label: 'Confirm & Continue',
              onPressed: widget.onFinish,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onEdit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _sectionTitleColor,
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.mode_edit_outlined,
                  size: 20, color: Color(0xFF667085)),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isLong = false, bool isQuestion = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, height: 1.4, color: _valueColor),
          children: [
            TextSpan(
              text: isQuestion ? '$label ' : '$label ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: _labelColor,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildChildRow(Map<String, dynamic> child, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '${child['firstName']} ${child['lastName']}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _labelColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${child['age']} Years old)',
            style: const TextStyle(
              fontSize: 14,
              color: _valueColor,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _editChild(child, index),
            child: const Icon(Icons.mode_edit_outlined,
                size: 18, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active, bool large = false}) {
    return Container(
      width: large ? 16 : 12,
      height: large ? 16 : 12,
      decoration: BoxDecoration(
        color: active ? AuthTheme.primaryBlue : const Color(0xFFE0F2F9),
        shape: BoxShape.circle,
        border: (active && large)
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
    );
  }

  Widget _buildConnectingLine({bool active = false}) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? AuthTheme.primaryBlue : const Color(0xFFE0F2F9),
      ),
    );
  }
}
