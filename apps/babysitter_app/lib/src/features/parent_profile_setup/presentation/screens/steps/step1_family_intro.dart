import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/parent_profile_providers.dart';
import 'add_item_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Step 1: Family Basics
/// Matches design: "Upload Photo", Family Name, Members, Pets, Bio
class Step1FamilyIntro extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step1FamilyIntro({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step1FamilyIntro> createState() => _Step1FamilyIntroState();
}

class _Step1FamilyIntroState extends ConsumerState<Step1FamilyIntro> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _familyNameController = TextEditingController();
  final _numPetsController = TextEditingController();
  final _bioController = TextEditingController();

  // State
  File? _image;
  String? _familyMembersCount;
  bool _hasPets = false;
  final Map<String, bool> _petTypes = {
    'Cat': false,
    'Dog': false,
    'Birds': false,
  };

  // Language State
  final _numLanguagesController = TextEditingController();
  bool _hasSecondLanguage = false;
  bool _isLanguagesExpanded = false;
  final Map<String, bool> _languages = {
    'French': false,
    'Spanish': false,
    'English': false,
  };

  static const _bgBlue =
      Color(0xFFF3FAFD); // Light blue background from screenshot
  static const _textDark = Color(0xFF1A1A1A);

  @override
  void dispose() {
    _familyNameController.dispose();
    _numPetsController.dispose();
    _numLanguagesController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _onNext() async {
    if (_formKey.currentState!.validate()) {
      // Gather Data
      final data = {
        'familyName': _familyNameController.text,
        'numberOfFamilyMembers': int.tryParse(_familyMembersCount ?? '0') ?? 0,
        'familyBio': _bioController.text,
        'hasPets': _hasPets,
        'numberOfPets':
            _hasPets ? (int.tryParse(_numPetsController.text) ?? 0) : 0,
        'petTypes':
            _petTypes.entries.where((e) => e.value).map((e) => e.key).toList(),
        'speaksOtherLanguages': _hasSecondLanguage,
        'numberOfLanguages': _hasSecondLanguage
            ? (int.tryParse(_numLanguagesController.text) ?? 0)
            : 0,
        'languages':
            _languages.entries.where((e) => e.value).map((e) => e.key).toList(),
      };

      // Save to profileData for summary
      widget.profileData.addAll(data);

      // Call API
      print('DEBUG: Calling updateProfile with data: $data');
      final success = await ref
          .read(parentProfileControllerProvider.notifier)
          .updateProfile(step: 1, data: data, profilePhoto: _image);
      print('DEBUG: updateProfile result: $success');

      if (success && mounted) {
        widget.onNext();
      } else {
        print(
            'DEBUG: Not proceeding because success=$success or mounted=$mounted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch controller state for loading/error
    final state = ref.watch(parentProfileControllerProvider);
    final isLoading = state.isLoading;

    // Listen for errors
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
        // ... (Keep existing AppBar code, maybe extract to method if too long but here we just keep structure)
        backgroundColor: _bgBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          '1 of 4',
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
                _buildDot(active: true, large: true),
                _buildConnectingLine(),
                _buildDot(active: false),
                _buildConnectingLine(),
                _buildDot(active: false),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ... (Keep existing header code)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Upload Photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(optional)',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textDark.withAlpha(128),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.info_outline,
                      size: 18, color: Color(0xFF98A2B3)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Upload a photo to help personalize your profile',
                style: TextStyle(
                  fontSize: 14,
                  color: _textDark.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Photo Placeholder
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: _image == null
                        ? Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: AuthTheme.primaryBlue,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Family Name
              _buildInputContainer(
                child: TextFormField(
                  controller: _familyNameController,
                  style: const TextStyle(color: _textDark),
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Family Name',
                        style:
                            TextStyle(color: Color(0xFF667085), fontSize: 16),
                        children: [
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Number of Family Members Dropdown
              _buildInputContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: _familyMembersCount,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF667085)),
                    style: const TextStyle(fontSize: 16, color: _textDark),
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'Number of Family Members',
                          style:
                              TextStyle(color: Color(0xFF667085), fontSize: 16),
                          children: [
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: ['2', '3', '4', '5', '6+']
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(color: _textDark))))
                        .toList(),
                    onChanged: (v) => setState(() => _familyMembersCount = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pets Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _hasPets,
                      activeColor: AuthTheme.primaryBlue,
                      side: const BorderSide(
                          color: Color(0xFFD0D5DD), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onChanged: (v) => setState(() => _hasPets = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pets:',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textDark.withAlpha(200),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              if (_hasPets) ...[
                const SizedBox(height: 16),
                // Number of Pets
                _buildInputContainer(
                  child: TextFormField(
                    controller: _numPetsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: const TextStyle(color: _textDark),
                    decoration: InputDecoration(
                      hintText: 'Number of Pets',
                      hintStyle: const TextStyle(color: Color(0xFF667085)),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Pet Types
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 2,
                          offset: const Offset(0, 1))
                    ],
                  ),
                  child: Column(
                    children: _petTypes.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(key,
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF475467))),
                            const Spacer(),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _petTypes[key],
                                activeColor: AuthTheme.primaryBlue,
                                side:
                                    const BorderSide(color: Color(0xFFD0D5DD)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                onChanged: (v) =>
                                    setState(() => _petTypes[key] = v ?? false),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Other
                InkWell(
                  onTap: () {
                    _showAddItemDialog('Add Pet Type', (val) {
                      setState(() {
                        _petTypes[val] = true;
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text('Other',
                            style: TextStyle(color: Color(0xFF98A2B3))),
                        const Spacer(),
                        const Icon(Icons.add, color: Color(0xFF475467)),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Do You Speak Another Language? Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _hasSecondLanguage,
                      activeColor: AuthTheme.primaryBlue,
                      side: const BorderSide(
                          color: Color(0xFFD0D5DD), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onChanged: (v) =>
                          setState(() => _hasSecondLanguage = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Do You Speak Another Language?',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textDark.withAlpha(200),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              if (_hasSecondLanguage) ...[
                const SizedBox(height: 12),

                // Number of Languages
                _buildInputContainer(
                  child: TextFormField(
                    controller: _numLanguagesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: const TextStyle(color: _textDark),
                    decoration: InputDecoration(
                      hintText: 'Number of Languages',
                      hintStyle: const TextStyle(color: Color(0xFF667085)),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Select Languages Accordion
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      InkWell(
                        onTap: () => setState(
                            () => _isLanguagesExpanded = !_isLanguagesExpanded),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Languages',
                                style: TextStyle(
                                  color:
                                      const Color(0xFF1A1A1A).withOpacity(0.6),
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                _isLanguagesExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xFF667085),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // List
                      if (_isLanguagesExpanded) ...[
                        const Divider(height: 1, color: Color(0xFFEAECF0)),
                        ..._languages.keys.map((key) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(key,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF475467))),
                                const Spacer(),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _languages[key],
                                    activeColor: AuthTheme.primaryBlue,
                                    side: const BorderSide(
                                        color: Color(0xFFD0D5DD)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    onChanged: (v) => setState(
                                        () => _languages[key] = v ?? false),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        // Other Option
                        const Divider(height: 1, color: Color(0xFFEAECF0)),
                        InkWell(
                          onTap: () {
                            _showAddItemDialog('Add Language', (val) {
                              setState(() {
                                _languages[val] = true;
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Text('Other',
                                    style: TextStyle(
                                        color: Color(0xFF667085),
                                        fontSize: 16)),
                                const Spacer(),
                                const Icon(Icons.add,
                                    color: Color(0xFF667085), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Family Bio
              Container(
                height: 120,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 2,
                        offset: const Offset(0, 1))
                  ],
                ),
                child: TextFormField(
                  controller: _bioController,
                  maxLines: null,
                  style: const TextStyle(color: _textDark),
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Family Bio',
                        style:
                            TextStyle(color: Color(0xFF667085), fontSize: 16),
                        children: [
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 32),

              // Next Button
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryActionButton(
                      label: 'Next',
                      onPressed: _onNext,
                    ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog(
      String title, Function(String) onAdded) async {
    await showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: title,
        onAdd: onAdded,
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDot({required bool active, bool large = false}) {
    return Container(
      width: large ? 16 : 12,
      height: large ? 16 : 12,
      decoration: BoxDecoration(
        color: active ? AuthTheme.primaryBlue : const Color(0xFFE0F2F9),
        shape: BoxShape.circle,
        border: active
            ? Border.all(color: Colors.white, width: 2)
            : null, // Ring effect for active?
      ),
    );
  }

  Widget _buildConnectingLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: const Color(0xFFE0F2F9),
      ),
    );
  }
}
