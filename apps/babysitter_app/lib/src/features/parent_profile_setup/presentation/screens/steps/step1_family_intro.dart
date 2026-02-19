import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:core/core.dart';
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
  static const Set<String> _defaultPetTypes = {
    'Cat',
    'Dog',
    'Birds',
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
  static const Set<String> _defaultLanguages = {
    'French',
    'Spanish',
    'English',
  };

  static const _bgBlue =
      AppColors.surfaceTint; // Light blue background from screenshot
  static const _textDark = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _hydrateFromProfileData();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _numPetsController.dispose();
    _numLanguagesController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _hydrateFromProfileData() {
    final data = widget.profileData;
    if (data.isEmpty) return;

    _familyNameController.text = data['familyName']?.toString() ?? '';
    _bioController.text = data['familyBio']?.toString() ?? '';

    final rawMembers = data['numberOfFamilyMembers'];
    _familyMembersCount = _normalizeFamilyMembers(rawMembers);

    final petTypes =
        (data['petTypes'] as List?)?.map((e) => e.toString()).toList() ?? [];
    _hasPets = data['hasPets'] == true || petTypes.isNotEmpty;
    final numPets = data['numberOfPets'];
    _numPetsController.text =
        (numPets != null && numPets.toString() != '0') ? '$numPets' : '';

    // Reset default pet types, then apply selections
    for (final key in _petTypes.keys) {
      _petTypes[key] = petTypes.contains(key);
    }
    for (final pet in petTypes) {
      _petTypes.putIfAbsent(pet, () => true);
      _petTypes[pet] = true;
    }

    final languages =
        (data['languages'] as List?)?.map((e) => e.toString()).toList() ?? [];
    _hasSecondLanguage =
        data['speaksOtherLanguages'] == true || languages.isNotEmpty;
    final numLanguages = data['numberOfLanguages'];
    _numLanguagesController.text = (numLanguages != null &&
            numLanguages.toString().isNotEmpty &&
            numLanguages.toString() != '0')
        ? '$numLanguages'
        : (languages.isNotEmpty ? '${languages.length}' : '');

    for (final key in _languages.keys) {
      _languages[key] = languages.contains(key);
    }
    for (final lang in languages) {
      _languages.putIfAbsent(lang, () => true);
      _languages[lang] = true;
    }
  }

  String? _normalizeFamilyMembers(dynamic rawMembers) {
    if (rawMembers == null) return null;
    if (rawMembers is String) {
      final trimmed = rawMembers.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed == '6+') return '6+';
      final parsed = int.tryParse(trimmed);
      if (parsed == null) return null;
      if (parsed < 2) return null;
      return parsed >= 6 ? '6+' : '$parsed';
    }
    if (rawMembers is num) {
      final value = rawMembers.toInt();
      if (value < 2) return null;
      return value >= 6 ? '6+' : '$value';
    }
    return null;
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
              const SizedBox(height: 6),
              Text(
                'Profiles with a photo help build trust and connection.',
                style: TextStyle(
                  fontSize: 13,
                  color: _textDark.withAlpha(128),
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
                        ? const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: AppColors.secondary,
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
                      text: const TextSpan(
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
                    initialValue: _familyMembersCount,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF667085)),
                    style: const TextStyle(fontSize: 16, color: _textDark),
                    decoration: InputDecoration(
                      label: RichText(
                        text: const TextSpan(
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
                      activeColor: AppColors.secondary,
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
                    decoration: const InputDecoration(
                      hintText: 'Number of Pets',
                      hintStyle: TextStyle(color: Color(0xFF667085)),
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
                      final isCustom = !_defaultPetTypes.contains(key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                key,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF475467),
                                ),
                              ),
                            ),
                            if (isCustom) ...[
                              IconButton(
                                onPressed: () {
                                  _showEditItemDialog(
                                    title: 'Edit Pet Type',
                                    initialValue: key,
                                    onSaved: (val) {
                                      setState(() {
                                        _renameMapKey(_petTypes, key, val);
                                      });
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined,
                                    size: 18, color: Color(0xFF98A2B3)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _petTypes.remove(key);
                                  });
                                },
                                icon: const Icon(Icons.delete_outline,
                                    size: 18, color: Color(0xFF98A2B3)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                            ] else
                              const SizedBox(width: 12),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _petTypes[key],
                                activeColor: AppColors.secondary,
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
                    child: const Row(
                      children: [
                        Text('Other',
                            style: TextStyle(color: Color(0xFF98A2B3))),
                        Spacer(),
                        Icon(Icons.add, color: Color(0xFF475467)),
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
                      activeColor: AppColors.secondary,
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
                    decoration: const InputDecoration(
                      hintText: 'Number of Languages',
                      hintStyle: TextStyle(color: Color(0xFF667085)),
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
                          final isCustom = !_defaultLanguages.contains(key);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    key,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF475467),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (isCustom) ...[
                                  IconButton(
                                    onPressed: () {
                                      _showEditItemDialog(
                                        title: 'Edit Language',
                                        initialValue: key,
                                        onSaved: (val) {
                                          setState(() {
                                            _renameMapKey(_languages, key, val);
                                          });
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 18, color: Color(0xFF98A2B3)),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _languages.remove(key);
                                      });
                                    },
                                    icon: const Icon(Icons.delete_outline,
                                        size: 18, color: Color(0xFF98A2B3)),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                ]
                                else
                                  const SizedBox(width: 12),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _languages[key],
                                    activeColor: AppColors.secondary,
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
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Text('Other',
                                    style: TextStyle(
                                        color: Color(0xFF667085),
                                        fontSize: 16)),
                                Spacer(),
                                Icon(Icons.add,
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
                      text: const TextSpan(
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

  Future<void> _showEditItemDialog({
    required String title,
    required String initialValue,
    required Function(String) onSaved,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: title,
        initialValue: initialValue,
        confirmLabel: 'Save',
        onAdd: onSaved,
      ),
    );
  }

  void _renameMapKey(Map<String, bool> map, String oldKey, String newKey) {
    final trimmed = newKey.trim();
    if (trimmed.isEmpty || oldKey == trimmed) {
      return;
    }
    final oldValue = map[oldKey] ?? false;
    final existingValue = map[trimmed] ?? false;
    map.remove(oldKey);
    map[trimmed] = existingValue || oldValue;
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
        color: active ? AppColors.secondary : AppColors.surfaceTint,
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
        color: AppColors.surfaceTint,
      ),
    );
  }
}
