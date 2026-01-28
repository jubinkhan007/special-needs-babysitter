import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step3Location extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Location({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step3Location> createState() => _Step3LocationState();
}

class _Step3LocationState extends ConsumerState<Step3Location> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = Color(0xFF88CBE6);

  bool _isLocating = false;
  GoogleMapController? _mapController;

  // Dark/Night mode map style
  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8ec3b9"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1a3646"}]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#4b6878"}]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#64779e"}]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#4b6878"}]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#334e87"}]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [{"color": "#283d6a"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#6f9ba5"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#3C7680"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{"color": "#304a7d"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#2c6675"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#255763"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#b0d5ce"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#283d6a"}]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [{"color": "#3a4762"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#0e1626"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#4e6d70"}]
  }
]
''';

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Widget _buildMapView(dynamic state) {
    // Default to San Francisco if no location set
    final lat = state.latitude ?? 37.7749;
    final lng = state.longitude ?? -122.4194;
    final center = LatLng(lat, lng);

    return Stack(
      children: [
        // Google Map with dark style
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 11.0,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            controller.setMapStyle(_darkMapStyle);
          },
          markers: {
            Marker(
              markerId: const MarkerId('center'),
              position: center,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueCyan,
              ),
            ),
          },
          circles: {
            Circle(
              circleId: const CircleId('radius'),
              center: center,
              radius: 8000, // 8km radius
              fillColor: _primaryBlue.withOpacity(0.25),
              strokeColor: _primaryBlue.withOpacity(0.5),
              strokeWidth: 2,
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
        ),
        // Google attribution overlay (bottom right)
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              'Map data \u00a9 Google',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied. Please enable in settings.';
      }

      final position = await Geolocator.getCurrentPosition();

      // Reverse geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        // Construct address like "City, State"
        final city = place.locality ?? '';
        final state = place.administrativeArea ?? '';
        final address = '$city, $state';

        ref.read(sitterProfileSetupControllerProvider.notifier).updateLocation(
            address: address, lat: position.latitude, lng: position.longitude);

        // Animate map to new location
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, 
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state to update UI if needed (e.g. show address in search bar)
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final controller = ref.read(sitterProfileSetupControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFD),
      appBar: OnboardingHeader(
        currentStep: 3,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 3, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.location_on_outlined,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Set Your Home Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Helps families find you nearby. You can update it anytime.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textDark.withOpacity(0.7),
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1))
                        ]),
                    child: TextField(
                      onChanged: (val) =>
                          controller.updateLocation(address: val),
                      controller: TextEditingController(text: state.address)
                        ..selection = TextSelection.fromPosition(
                            TextPosition(offset: state.address?.length ?? 0)),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: _textDark,
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter your address or city',
                        hintStyle: TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 16,
                            fontFamily: 'Inter'),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF98A2B3)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Use Current Location Button
                  OutlinedButton.icon(
                    onPressed: _isLocating ? null : _getCurrentLocation,
                    icon: _isLocating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _primaryBlue))
                        : const Icon(Icons.my_location, color: _primaryBlue),
                    label: Text(
                        _isLocating ? 'Locating...' : 'Use my Current Location',
                        style: const TextStyle(
                            color: _primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primaryBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Map with dark theme and radius overlay
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1d2c4d), // Dark map fallback
                      ),
                      child: _buildMapView(state),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PrimaryActionButton(
            label: 'Save Location & Continue',
            onPressed: () {
              if (state.address == null || state.address!.isEmpty) {
                AppToast.show(context, 
                    const SnackBar(content: Text('Please set a location')));
                return;
              }
              widget.onNext();
            },
          ),
        ),
      ),
    );
  }
}
