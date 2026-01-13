import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/booking.dart';
import '../domain/booking_status.dart';

class BookingsController extends StateNotifier<List<Booking>> {
  BookingsController() : super(_dummyData);

  // Expose as method per instruction or just usage?
  // "UI only calls: final items = controller.bookingsFor(currentStatus);"
  // But StateNotifier usually exposes state.
  // I'll make this a simple class or provider that holds data.
  // Instructions: "Create BookingsController that exposes: List<Booking> allBookings, List<Booking> bookingsFor(status)"

  List<Booking> get allBookings => state;

  List<Booking> bookingsFor(BookingStatus status) {
    return state.where((b) => b.status == status).toList();
  }

  static final List<Booking> _dummyData = [
    Booking(
      id: '1',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 5, 20),
      status: BookingStatus.active,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '2',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 5, 20),
      status: BookingStatus.pending,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '3',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 5, 20),
      status: BookingStatus.upcoming,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '4',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 5, 20),
      status: BookingStatus.completed,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
  ];
}

final bookingsControllerProvider = Provider((ref) => BookingsController());
