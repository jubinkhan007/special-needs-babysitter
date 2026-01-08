import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/parent_profile_providers.dart';
import '../../widgets/add_child_dialog.dart';

/// Step 2: Add a Child
/// Matches new Figma design: Blue baby icon, "Add Child" dark button // List view
class Step2Children extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step2Children({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step2Children> createState() => _Step2ChildrenState();
}

class _Step2ChildrenState extends ConsumerState<Step2Children> {
  late List<Map<String, dynamic>> _kids;
  static const _bgBlue = Color(0xFFF3FAFD);

  @override
  void initState() {
    super.initState();
    _kids = List<Map<String, dynamic>>.from(
        widget.profileData['kids'] as List? ?? []);
  }

  Future<void> _showAddChildDialog(
      [Map<String, dynamic>? existingChild, int? index]) async {
    await showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        existingChild: existingChild,
        onSave: (childData) async {
          // 1. Call API
          final success = await ref
              .read(parentProfileControllerProvider.notifier)
              .addUpdateChild(childData);

          // 2. Update Local State
          if (success) {
            setState(() {
              if (index != null) {
                _kids[index] = childData;
              } else {
                _kids.add(childData);
              }
              widget.profileData['kids'] = _kids;
            });
          }
        },
      ),
    );
  }

  Future<void> _onNext() async {
    // Call API to update step to 2 (Complete)
    final success = await ref
        .read(parentProfileControllerProvider.notifier)
        .updateProfile(step: 2, data: {});

    if (success && mounted) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch controller state
    final state = ref.watch(parentProfileControllerProvider);
    final isLoading = state.isLoading;

    // Error Listener
    ref.listen(parentProfileControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
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
          'Step 2 of 4',
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
                _buildDot(active: true, large: true), // Step 2 active
                _buildConnectingLine(),
                _buildDot(active: false),
                _buildConnectingLine(),
                _buildDot(active: false),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Fix alignment
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F0FA), // Light blue
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.child_care, // Better baby icon
                      size: 36,
                      color: AuthTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Add a Child',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add Child Button (Only visible if list is empty, or maybe always?)
                  // Figma shows "Add Child" button when list is empty.
                  if (_kids.isEmpty) ...[
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _showAddChildDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1D2939), // Dark button
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add Child',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // List of added kids - Simplified Flat Design
                    ..._kids.asMap().entries.map((entry) {
                      final index = entry.key;
                      final kid = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${kid['firstName']} ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(${kid['age']} Years old)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xFF1A1A1A)
                                          .withAlpha(153),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 20, color: Color(0xFF667085)),
                              onPressed: () => _showAddChildDialog(kid, index),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    // "Add Another Child" Button - Dark Navy
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _showAddChildDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1D2939), // Dark button
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Another Child'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFEAECF0), thickness: 1),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Footer
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                TextButton(
                  onPressed: _onNext, // Treat Skip as Next (Update step)
                  child: const Text(
                    'Skip for Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475467),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 140,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryActionButton(
                          label: 'Next',
                          onPressed: _onNext,
                        ),
                ),
              ],
            ),
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
