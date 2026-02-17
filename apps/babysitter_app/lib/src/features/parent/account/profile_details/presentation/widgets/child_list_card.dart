import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import '../profile_details_ui_constants.dart';
import 'common_profile_widgets.dart';

class ChildListCard extends StatelessWidget {
  final List<Child> children;
  final Function(String) onEditChild;
  final Function(String) onDeleteChild;
  final VoidCallback onAddChild;

  const ChildListCard({
    super.key,
    required this.children,
    required this.onEditChild,
    required this.onDeleteChild,
    required this.onAddChild,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Child',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ProfileDetailsUI.primaryText,
              )),
          const SizedBox(height: 12),
          ...children.map((child) => _buildChildItem(child)),
          const SizedBox(height: 16),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildChildItem(Child child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 16, color: ProfileDetailsUI.primaryText),
              children: [
                TextSpan(
                  text: child.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' (${child.ageDisplay})',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ProfileDetailsUI.secondaryText),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => onEditChild(child.id),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons
                    .edit, // Changed to filled edit icon to match design better if needed, or stick to edit_outlined
                size: 20,
                color: ProfileDetailsUI.secondaryText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => onDeleteChild(child.id),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.delete_outline,
                size: 20,
                color: ProfileDetailsUI.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: ElevatedButton(
        onPressed: onAddChild,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F2937),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Text('Add Child'),
      ),
    );
  }
}
