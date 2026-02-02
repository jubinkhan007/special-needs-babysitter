import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../../../../../common/theme/auth_theme.dart';
import '../../providers/parent_profile_providers.dart';
import '../../../../parent/account/profile_details/presentation/widgets/edit_insurance_plan_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step3EmergencyAndInsurance extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step3EmergencyAndInsurance({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step3EmergencyAndInsurance> createState() =>
      _Step3EmergencyAndInsuranceState();
}

class _Step3EmergencyAndInsuranceState
    extends ConsumerState<Step3EmergencyAndInsurance> {
  final _formKey = GlobalKey<FormState>();

  bool _wantToAddContact = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  // Store insurance plans locally for this step
  List<InsurancePlan> _insurancePlans = [];

  static const _bgBlue = Color(0xFFF3FAFD);

  @override
  void initState() {
    super.initState();
    // Initialize from profileData if available
    final contacts = widget.profileData['emergencyContacts'] as List? ?? [];
    if (contacts.isNotEmpty) {
      final c = contacts.first;
      _nameController.text = c['name'] ?? '';
      _relationController.text = c['relationship'] ?? '';
      _phoneController.text = c['phone'] ?? '';
      _emailController.text = c['email'] ?? '';
      _addressController.text = c['address'] ?? '';
      _instructionsController.text = c['specialInstructions'] ?? '';
      _wantToAddContact = true;
    } else {
      _wantToAddContact = false;
    }

    final plans = widget.profileData['insurancePlans'];
    if (plans is List) {
      _insurancePlans = plans.map((plan) {
        if (plan is InsurancePlan) return plan;
        if (plan is Map<String, dynamic>) {
          return InsurancePlan(
            planName: plan['planName']?.toString() ?? '',
            insuranceType: plan['insuranceType']?.toString() ?? '',
            coverageAmount:
                double.tryParse(plan['coverageAmount'].toString()) ?? 0.0,
            monthlyPremium:
                double.tryParse(plan['monthlyPremium'].toString()) ?? 0.0,
            yearlyPremium:
                double.tryParse(plan['yearlyPremium'].toString()) ?? 0.0,
            description: plan['description']?.toString() ?? '',
            isActive: plan['isActive'] == true,
          );
        }
        return InsurancePlan(
          planName: '',
          insuranceType: '',
          coverageAmount: 0.0,
          monthlyPremium: 0.0,
          yearlyPremium: 0.0,
          description: '',
          isActive: false,
        );
      }).toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _onSkip() {
    // Treat skip as moving next without validating/saving emergency contact
    // But maybe we save empty?
    widget.onNext();
  }

  Future<void> _onNext() async {
    if (_wantToAddContact) {
      if (_formKey.currentState!.validate()) {
        final contactData = {
          'fullName': _nameController.text, // Backend expects fullName
          'relationshipToChild': _relationController.text, // Backend key
          'primaryPhone': _phoneController.text, // Backend key
          'email': _emailController.text,
          'address': _addressController.text,
          'specialInstructions': _instructionsController.text,
        };

        final insuranceData =
            _insurancePlans.map((plan) => plan.toMap()).toList(); // List<Map>

        // Construct payload for Step 3
        // Backend ProfileDetailsRemoteDataSource expects: { emergencyContact: {...}, insurancePlans: [...] }
        // BUT ParentProfileRepositoryImpl expects us to pass `data`.
        // Let's create the merged data map.
        final data = {
          'emergencyContact': contactData,
          'insurancePlans': insuranceData,
        };

        // Update Controller
        final success = await ref
            .read(parentProfileControllerProvider.notifier)
            .updateProfile(step: 3, data: data);

        if (success && mounted) {
          // Also update local profileData for the Review Step
          widget.profileData['emergencyContacts'] = [
            {
              'name': _nameController.text,
              'relationship': _relationController.text,
              'phone': _phoneController.text,
              'email': _emailController.text,
              'address': _addressController.text,
              'specialInstructions': _instructionsController.text,
            } // Mapped for UI
          ];
          widget.profileData['insurancePlans'] = _insurancePlans;

          widget.onNext();
        }
      }
    } else {
      // Just Insurance?
      if (_insurancePlans.isNotEmpty) {
        final insuranceData =
            _insurancePlans.map((plan) => plan.toMap()).toList();
        final data = {
          'insurancePlans': insuranceData,
          // Empty contact?
        };
        final success = await ref
            .read(parentProfileControllerProvider.notifier)
            .updateProfile(step: 3, data: data);
        if (success && mounted) widget.onNext();
      } else {
        widget.onNext();
      }
    }
  }

  Future<void> _showAddInsuranceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => EditInsurancePlanDialog(
        onSave: (planMap) {
          // Convert map back to Entity to store in list
          // Mapping manual to ensure safety or constructor?
          // Using strict constructor
          final newPlan = InsurancePlan(
            planName: planMap['planName'],
            insuranceType: planMap['insuranceType'],
            coverageAmount:
                double.tryParse(planMap['coverageAmount'].toString()) ?? 0.0,
            monthlyPremium:
                double.tryParse(planMap['monthlyPremium'].toString()) ?? 0.0,
            yearlyPremium:
                double.tryParse(planMap['yearlyPremium'].toString()) ?? 0.0,
            description: planMap['description'],
            isActive: planMap['isActive'],
          );

          setState(() {
            _insurancePlans.add(newPlan);
          });
        },
      ),
    );
  }

  Future<void> _showEditInsuranceDialog(InsurancePlan plan, int index) async {
    await showDialog(
      context: context,
      builder: (context) => EditInsurancePlanDialog(
        initialPlan: plan,
        onSave: (planMap) {
          final updatedPlan = InsurancePlan(
            planName: planMap['planName'],
            insuranceType: planMap['insuranceType'],
            coverageAmount:
                double.tryParse(planMap['coverageAmount'].toString()) ?? 0.0,
            monthlyPremium:
                double.tryParse(planMap['monthlyPremium'].toString()) ?? 0.0,
            yearlyPremium:
                double.tryParse(planMap['yearlyPremium'].toString()) ?? 0.0,
            description: planMap['description'],
            isActive: planMap['isActive'],
          );

          setState(() {
            _insurancePlans[index] = updatedPlan;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch loading state
    final state = ref.watch(parentProfileControllerProvider);
    final isLoading = state.isLoading;

    // Error Listener
    ref.listen(parentProfileControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        AppToast.show(context, 
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

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
          '3 of 4',
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
                _buildDot(active: true, large: true),
                _buildConnectingLine(),
                _buildDot(active: false),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6F0FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 36,
                  color: AuthTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Emergency Contact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),

              // Checkbox row
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _wantToAddContact,
                      activeColor: AuthTheme.primaryBlue,
                      side: const BorderSide(
                          color: Color(0xFFD0D5DD), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onChanged: (v) =>
                          setState(() => _wantToAddContact = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Want to add Emergency Contact?',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1A1A1A).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (_wantToAddContact) ...[
                _buildTextField(_nameController, "Full Name*"),
                const SizedBox(height: 12),
                _buildTextField(_relationController, "Relationship to Child*"),
                const SizedBox(height: 12),
                _buildTextField(_phoneController, "Primary Phone Number*",
                    isPhone: true),
                const SizedBox(height: 12),
                _buildTextField(_emailController, "Email Address",
                    isEmail: true),
                const SizedBox(height: 12),
                _buildTextField(_addressController, "Address"),
                const SizedBox(height: 12),
                _buildTextField(_instructionsController,
                    "Special Instructions*"), // Screenshot shows *
                const SizedBox(height: 24),
              ],

              // Insurance Section
              // Header mimicking the expansion tile or just a button?
              // Screenshot shows "Add an Insurance Plan" with info icon and + sign.
              // It looks like a button container.
              InkWell(
                onTap: _showAddInsuranceDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Add an Insurance Plan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF667085),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF98A2B3)),
                      const Spacer(),
                      const Icon(Icons.add, color: Color(0xFF667085)),
                    ],
                  ),
                ),
              ),

              // Show added insurance plans briefly or not?
              // UI screenshot doesn't show list, but logic implies we can add.
              // Let's list simplified if added.
              if (_insurancePlans.isNotEmpty) ...[
                const SizedBox(height: 12),
                ..._insurancePlans.asMap().entries.map((entry) {
                  final index = entry.key;
                  final plan = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            plan.planName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: Color(0xFF667085)),
                          onPressed: () =>
                              _showEditInsuranceDialog(plan, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: Color(0xFF667085)),
                          onPressed: () {
                            setState(() {
                              _insurancePlans.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onSkip,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFD0D5DD)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Skip',
                          style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF75CFF0), // Light blue
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Next',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPhone = false, bool isEmail = false}) {
    // Reusing style from EditInsurancePlanDialog or Step 1
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D101828),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Color(0xFF1A1A1A), // Dark text color for visibility
          fontSize: 16,
        ),
        keyboardType: isPhone
            ? TextInputType.phone
            : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        inputFormatters:
            isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF667085), fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AuthTheme.primaryBlue),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          isDense: true,
        ),
        validator: (value) {
          if (hint.endsWith('*')) {
            if (value == null || value.isEmpty) {
              return '${hint.replaceAll('*', '')} is required';
            }
            if (isPhone && value.length < 10) {
              return 'Please enter a valid phone number (at least 10 digits)';
            }
          }
          if (isEmail && value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          return null;
        },
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
