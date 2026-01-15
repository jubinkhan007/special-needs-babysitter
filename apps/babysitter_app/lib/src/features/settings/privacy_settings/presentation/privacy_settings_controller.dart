import 'package:flutter/material.dart';
import 'package:babysitter_app/src/common_widgets/privacy_radio_section.dart';

/// Controller for Privacy Settings screen
class PrivacySettingsController extends ChangeNotifier {
  PrivacyChoice _personalDataIntelligence = PrivacyChoice.no;
  PrivacyChoice _locationSharingUpdates = PrivacyChoice.no;
  PrivacyChoice _accountControl = PrivacyChoice.no;
  PrivacyChoice _usageDiagnostics = PrivacyChoice.no;

  PrivacyChoice get personalDataIntelligence => _personalDataIntelligence;
  PrivacyChoice get locationSharingUpdates => _locationSharingUpdates;
  PrivacyChoice get accountControl => _accountControl;
  PrivacyChoice get usageDiagnostics => _usageDiagnostics;

  void setPersonalDataIntelligence(PrivacyChoice value) {
    _personalDataIntelligence = value;
    notifyListeners();
  }

  void setLocationSharingUpdates(PrivacyChoice value) {
    _locationSharingUpdates = value;
    notifyListeners();
  }

  void setAccountControl(PrivacyChoice value) {
    _accountControl = value;
    notifyListeners();
  }

  void setUsageDiagnostics(PrivacyChoice value) {
    _usageDiagnostics = value;
    notifyListeners();
  }
}
