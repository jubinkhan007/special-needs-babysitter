import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/booking_flow_state.dart';

/// Provider for managing booking flow state across steps 1-4
final bookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>(
  (ref) => BookingFlowNotifier(),
);

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  BookingFlowNotifier() : super(const BookingFlowState());

  /// Initialize with sitter data from profile
  void initWithSitter({
    required String sitterId,
    required String sitterName,
    String? sitterAvatarUrl,
    double? sitterRating,
    String? sitterDistance,
    String? sitterResponseRate,
    String? sitterReliabilityRate,
    String? sitterExperience,
    List<String>? sitterBadges,
  }) {
    state = state.copyWith(
      sitterId: sitterId,
      sitterName: sitterName,
      sitterAvatarUrl: sitterAvatarUrl,
      sitterRating: sitterRating,
      sitterDistance: sitterDistance,
      sitterResponseRate: sitterResponseRate,
      sitterReliabilityRate: sitterReliabilityRate,
      sitterExperience: sitterExperience,
      sitterBadges: sitterBadges,
    );
  }

  /// Update step 1 data
  void updateStep1({
    required List<String> childIds,
    required List<String> childNames,
    required double payRate,
    String? additionalDetails,
    String? transportationMode,
    String? equipmentSafety,
    String? pickupDropoffDetails,
    String? pickupLocation,
    String? dropoffLocation,
    String? transportSpecialInstructions,
  }) {
    state = state.copyWith(
      selectedChildIds: childIds,
      selectedChildNames: childNames,
      payRate: payRate,
      additionalDetails: additionalDetails,
      transportationMode: transportationMode,
      equipmentSafety: equipmentSafety,
      pickupDropoffDetails: pickupDropoffDetails,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      transportSpecialInstructions: transportSpecialInstructions,
    );
  }

  /// Update step 2 data
  void updateStep2({
    required String jobTitle,
    required String dateRange,
    DateTime? startDate,
    DateTime? endDate,
    required String startTime,
    required String endTime,
  }) {
    state = state.copyWith(
      jobTitle: jobTitle,
      dateRange: dateRange,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Update step 3 data
  void updateStep3({
    required String streetAddress,
    String? aptUnit,
    required String city,
    required String addressState,
    required String zipCode,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? emergencyContactEmail,
    String? emergencyContactAddress,
    String? emergencyContactInstructions,
  }) {
    state = state.copyWith(
      streetAddress: streetAddress,
      aptUnit: aptUnit,
      city: city,
      state: addressState,
      zipCode: zipCode,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      emergencyContactEmail: emergencyContactEmail,
      emergencyContactAddress: emergencyContactAddress,
      emergencyContactInstructions: emergencyContactInstructions,
    );
  }

  /// Update selected payment method
  void updatePaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  /// Update location coordinates from geocoding
  void updateLocationCoordinates({
    required double latitude,
    required double longitude,
  }) {
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Reset state (e.g., after booking completed or cancelled)
  void reset() {
    state = const BookingFlowState();
  }
}
