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
    // Active (3 cards)
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
      sitterName: 'Emily Rose',
      distanceText: '3 Miles Away',
      rating: 4.8,
      responseRate: 98,
      reliabilityRate: 97,
      experienceText: '7 Years',
      scheduledDate: DateTime(2025, 5, 22),
      status: BookingStatus.active,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '3',
      sitterName: 'Sarah Johnson',
      distanceText: '8 Miles Away',
      rating: 4.2,
      responseRate: 90,
      reliabilityRate: 88,
      experienceText: '3 Years',
      scheduledDate: DateTime(2025, 5, 25),
      status: BookingStatus.active,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: false,
    ),

    // Upcoming (3 cards)
    Booking(
      id: '4',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 6, 10),
      status: BookingStatus.upcoming,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '5',
      sitterName: 'Maria Lopez',
      distanceText: '2 Miles Away',
      rating: 4.9,
      responseRate: 99,
      reliabilityRate: 98,
      experienceText: '10 Years',
      scheduledDate: DateTime(2025, 6, 15),
      status: BookingStatus.upcoming,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '6',
      sitterName: 'Jessica Brown',
      distanceText: '6 Miles Away',
      rating: 4.3,
      responseRate: 92,
      reliabilityRate: 90,
      experienceText: '4 Years',
      scheduledDate: DateTime(2025, 6, 20),
      status: BookingStatus.upcoming,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),

    // Pending (3 cards)
    Booking(
      id: '7',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 5, 28),
      status: BookingStatus.pending,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '8',
      sitterName: 'Anna Williams',
      distanceText: '4 Miles Away',
      rating: 4.6,
      responseRate: 94,
      reliabilityRate: 93,
      experienceText: '6 Years',
      scheduledDate: DateTime(2025, 5, 30),
      status: BookingStatus.pending,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: false,
    ),
    Booking(
      id: '9',
      sitterName: 'Linda Davis',
      distanceText: '7 Miles Away',
      rating: 4.4,
      responseRate: 91,
      reliabilityRate: 89,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 6, 1),
      status: BookingStatus.pending,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),

    // Completed (3 cards)
    Booking(
      id: '10',
      sitterName: 'Krystina',
      distanceText: '5 Miles Away',
      rating: 4.5,
      responseRate: 95,
      reliabilityRate: 95,
      experienceText: '5 Years',
      scheduledDate: DateTime(2025, 4, 15),
      status: BookingStatus.completed,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '11',
      sitterName: 'Patricia Moore',
      distanceText: '3 Miles Away',
      rating: 4.7,
      responseRate: 96,
      reliabilityRate: 94,
      experienceText: '8 Years',
      scheduledDate: DateTime(2025, 4, 10),
      status: BookingStatus.completed,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '12',
      sitterName: 'Nancy Taylor',
      distanceText: '5 Miles Away',
      rating: 4.1,
      responseRate: 88,
      reliabilityRate: 87,
      experienceText: '2 Years',
      scheduledDate: DateTime(2025, 4, 5),
      status: BookingStatus.completed,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: false,
    ),

    // Cancelled (3 cards)
    Booking(
      id: '13',
      sitterName: 'Karen White',
      distanceText: '6 Miles Away',
      rating: 4.0,
      responseRate: 85,
      reliabilityRate: 82,
      experienceText: '3 Years',
      scheduledDate: DateTime(2025, 3, 20),
      status: BookingStatus.cancelled,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: false,
    ),
    Booking(
      id: '14',
      sitterName: 'Betty Harris',
      distanceText: '4 Miles Away',
      rating: 4.3,
      responseRate: 90,
      reliabilityRate: 88,
      experienceText: '4 Years',
      scheduledDate: DateTime(2025, 3, 15),
      status: BookingStatus.cancelled,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: true,
    ),
    Booking(
      id: '15',
      sitterName: 'Dorothy Clark',
      distanceText: '9 Miles Away',
      rating: 3.9,
      responseRate: 80,
      reliabilityRate: 78,
      experienceText: '2 Years',
      scheduledDate: DateTime(2025, 3, 10),
      status: BookingStatus.cancelled,
      avatarAssetOrUrl: 'assets/images/user_avatar_placeholder.png',
      isVerified: false,
    ),
  ];
}

final bookingsControllerProvider = Provider((ref) => BookingsController());
