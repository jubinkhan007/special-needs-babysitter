import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domain/domain.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_kit/ui_kit.dart';
import '../profile_details_ui_constants.dart';

class EditProfileDetailsDialog extends StatefulWidget {
  final UserProfileDetails initialDetails;
  final Future<void> Function(Map<String, dynamic> data) onSave;
  final Future<String> Function(File file)? onUploadPhoto;

  const EditProfileDetailsDialog({
    super.key,
    required this.initialDetails,
    required this.onSave,
    this.onUploadPhoto,
  });

  @override
  State<EditProfileDetailsDialog> createState() =>
      _EditProfileDetailsDialogState();
}

class _EditProfileDetailsDialogState extends State<EditProfileDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _familyNameController;
  late TextEditingController _numPetsController;
  late TextEditingController _numLanguagesController;
  late TextEditingController _bioController;

  String? _familyMembersCount;
  bool _hasPets = false;
  late Map<String, bool> _petTypes;
  bool _hasSecondLanguage = false;
  late Map<String, bool> _languages;
  File? _image;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDetails;

    _familyNameController = TextEditingController(text: d.familyName);
    _bioController = TextEditingController(text: d.familyBio);
    _familyMembersCount = d.numberOfFamilyMembers > 0
        ? d.numberOfFamilyMembers.toString()
        : null; // Initialize dropdown
    // If > 6 or something not in list, might need handling, but assuming matching list for now

    _hasPets = d.hasPets;
    _numPetsController = TextEditingController(
        text: d.numberOfPets > 0 ? d.numberOfPets.toString() : '');

    // Initialize pet types from list to map
    _petTypes = {
      'Dog': false,
      'Cat': false,
      'Bird': false,
    };
    for (var type in d.petTypes) {
      _petTypes[type] = true;
    }
    // Handle "Other" types if needed, but for now strict set + dynamic addition logic from Step 1

    _hasSecondLanguage = d.speaksOtherLanguages;
    _numLanguagesController = TextEditingController(
        text: d.languages.isNotEmpty ? d.languages.length.toString() : '');

    _languages = {
      'Spanish': false,
      'French': false,
      'English': false,
    };
    for (var lang in d.languages) {
      // If lang is not in default map, add it
      _languages[lang] = true;
    }
  }

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

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      String? photoUrl;
      if (_image != null && widget.onUploadPhoto != null) {
        try {
          photoUrl = await widget.onUploadPhoto!(_image!);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error uploading photo: $e')));
            setState(() => _isSaving = false);
            return;
          }
        }
      }

      final selectedPetTypes =
          _petTypes.entries.where((e) => e.value).map((e) => e.key).toList();
      final selectedLanguages =
          _languages.entries.where((e) => e.value).map((e) => e.key).toList();

      final data = {
        if (photoUrl != null) 'photoUrl': photoUrl,
        'familyName': _familyNameController.text,
        'numberOfFamilyMembers': int.tryParse(_familyMembersCount ?? '0') ?? 0,
        'familyBio': _bioController.text,
        'hasPets': _hasPets,
        'numberOfPets':
            _hasPets ? int.tryParse(_numPetsController.text) ?? 0 : 0,
        'petTypes': selectedPetTypes,
        'speaksOtherLanguages': _hasSecondLanguage,
        // api calls for 'numberOfLanguages' if needed, or derived?
        'numberOfLanguages': _hasSecondLanguage
            ? int.tryParse(_numLanguagesController.text) ?? 0
            : 0,
        'languages': selectedLanguages,
        // 'photoUrl': handled separately optionally, or passed if supported
      };

      try {
        await widget.onSave(data);
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $e')));
          setState(() => _isSaving = false);
        }
      }
    }
  }

  Future<void> _showAddDialog(String title, Function(String) onAdd) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Add $title',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $title name',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAdd(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child:
                const Text('Add', style: TextStyle(color: Color(0xFF00A3E0))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header
          Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Edit Your Details",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937))),
                    IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                        onPressed: () => Navigator.of(context).pop()),
                  ])),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Flexible(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Reusing logic from Step 1
                            Center(
                                child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                  image: _image != null
                                      ? DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover)
                                      : (widget.initialDetails.user.avatarUrl !=
                                              null
                                          ? DecorationImage(
                                              image: NetworkImage(widget
                                                  .initialDetails
                                                  .user
                                                  .avatarUrl!),
                                              fit: BoxFit.cover)
                                          : null),
                                ),
                                child: (_image == null &&
                                        widget.initialDetails.user.avatarUrl ==
                                            null)
                                    ? Icon(Icons.camera_alt,
                                        size: 40, color: Colors.grey[500])
                                    : null,
                              ),
                            )),
                            const SizedBox(height: 24),

                            // Family Name
                            _buildInputContainer(
                              child: TextFormField(
                                controller: _familyNameController,
                                style:
                                    const TextStyle(color: Color(0xFF1F2937)),
                                decoration: _inputDecoration('Family Name'),
                                validator: (v) =>
                                    v?.isEmpty == true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Members Dropdown
                            _buildInputContainer(
                              child: DropdownButtonFormField<String>(
                                value: _familyMembersCount,
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF1F2937)),
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xFF6B7280)),
                                decoration: _inputDecoration(
                                    'Number of Family Members'),
                                items: ['2', '3', '4', '5', '6+']
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _familyMembersCount = v),
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Pets
                            _buildCheckboxTile('Pets', _hasPets,
                                (v) => setState(() => _hasPets = v ?? false)),
                            if (_hasPets) ...[
                              const SizedBox(height: 12),
                              _buildInputContainer(
                                child: TextFormField(
                                  controller: _numPetsController,
                                  style:
                                      const TextStyle(color: Color(0xFF1F2937)),
                                  decoration:
                                      _inputDecoration('Number of Pets'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: _hasPets
                                      ? (v) =>
                                          v?.isEmpty == true ? 'Required' : null
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(spacing: 8, children: [
                                ..._petTypes.keys.map((key) {
                                  return FilterChip(
                                    label: Text(key),
                                    selected: _petTypes[key] ?? false,
                                    backgroundColor: Colors.white,
                                    selectedColor: const Color(0xFFE0F2F9),
                                    checkmarkColor: const Color(0xFF00A3E0),
                                    labelStyle: TextStyle(
                                        color: _petTypes[key] == true
                                            ? const Color(0xFF0077A3)
                                            : const Color(0xFF4B5563)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          color: _petTypes[key] == true
                                              ? const Color(0xFF00A3E0)
                                              : const Color(0xFFD1D5DB)),
                                    ),
                                    onSelected: (v) =>
                                        setState(() => _petTypes[key] = v),
                                  );
                                }).toList(),
                                ActionChip(
                                  label: const Text('+ Other'),
                                  backgroundColor: Colors.white,
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF00A3E0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Color(0xFF00A3E0)),
                                  ),
                                  onPressed: () =>
                                      _showAddDialog('Pet Type', (val) {
                                    setState(() {
                                      _petTypes[val] = true;
                                    });
                                  }),
                                ),
                              ]),
                            ],
                            const SizedBox(height: 16),

                            // Languages
                            _buildCheckboxTile(
                                'Do You Speak Another Language?',
                                _hasSecondLanguage,
                                (v) => setState(
                                    () => _hasSecondLanguage = v ?? false)),
                            if (_hasSecondLanguage) ...[
                              const SizedBox(height: 12),
                              _buildInputContainer(
                                child: TextFormField(
                                  controller: _numLanguagesController,
                                  style:
                                      const TextStyle(color: Color(0xFF1F2937)),
                                  decoration:
                                      _inputDecoration('Number of Languages'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: _hasSecondLanguage
                                      ? (v) =>
                                          v?.isEmpty == true ? 'Required' : null
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(spacing: 8, children: [
                                ..._languages.keys.map((key) {
                                  return FilterChip(
                                    label: Text(key),
                                    selected: _languages[key] ?? false,
                                    backgroundColor: Colors.white,
                                    selectedColor: const Color(0xFFE0F2F9),
                                    checkmarkColor: const Color(0xFF00A3E0),
                                    labelStyle: TextStyle(
                                        color: _languages[key] == true
                                            ? const Color(0xFF0077A3)
                                            : const Color(0xFF4B5563)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          color: _languages[key] == true
                                              ? const Color(0xFF00A3E0)
                                              : const Color(0xFFD1D5DB)),
                                    ),
                                    onSelected: (v) =>
                                        setState(() => _languages[key] = v),
                                  );
                                }).toList(),
                                ActionChip(
                                  label: const Text('+ Other'),
                                  backgroundColor: Colors.white,
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF00A3E0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Color(0xFF00A3E0)),
                                  ),
                                  onPressed: () =>
                                      _showAddDialog('Language', (val) {
                                    setState(() {
                                      _languages[val] = true;
                                    });
                                  }),
                                ),
                              ]),
                            ],
                            const SizedBox(height: 16),

                            // Bio
                            _buildInputContainer(
                              child: TextFormField(
                                controller: _bioController,
                                style:
                                    const TextStyle(color: Color(0xFF1F2937)),
                                decoration: _inputDecoration('Family Bio'),
                                maxLines: 4,
                                validator: (v) =>
                                    v?.isEmpty == true ? 'Required' : null,
                              ),
                            ),
                          ])))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: _isSaving ? 'Saving...' : 'Save',
                onPressed: _isSaving ? null : _handleSave,
                // PrimaryButton should pull correct theme, usually blue
              ),
            ),
          ),
        ]));
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12), // 0.05 * 255 ~= 13
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.transparent), // Clean look
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
      filled: true,
      fillColor: Colors.white,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged) {
    return Theme(
      data: ThemeData(
          checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Color(0xFFD1D5DB)),
      )),
      child: CheckboxListTile(
        title: Text(title,
            style: const TextStyle(
                color: Color(0xFF374151), fontWeight: FontWeight.w500)),
        value: value,
        activeColor: const Color(0xFF00A3E0), // Primary Blue
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
