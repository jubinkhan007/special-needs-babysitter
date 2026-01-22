class ReviewModel {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class SitterModel {
  final String id;
  final String userId;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final double rating;
  final String location;
  final String distance;
  final int responseRate;
  final int reliabilityRate;
  final int experienceYears;
  final double hourlyRate;
  final List<String> badges;
  final String bio;
  final List<String> languages;
  final List<String> certifications;
  final bool willingToTravel;
  final String? travelRadius; // e.g. "Up to 15 km"
  final bool hasTransportation;
  final String? transportationType; // e.g. "Owns vehicle"
  final Map<String, bool> jobTypesAccepted;
  final bool openToNegotiating;
  final List<ReviewModel> reviews;
  final List<dynamic> availability;
  final List<String> ageRanges;

  const SitterModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    this.isVerified = true,
    required this.rating,
    required this.location,
    required this.distance,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceYears,
    required this.hourlyRate,
    this.badges = const [],
    this.bio =
        "Hi, I'm Krystina! I've been a sitter for over 5 years. I love kids and pets. I'm a certified CPR and First Aid instructor. I'm also a special needs certified sitter. I'm available for recurring, one-time, and emergency jobs.",
    this.languages = const [],
    this.certifications = const [],
    this.willingToTravel = false,
    this.travelRadius,
    this.hasTransportation = false,
    this.transportationType,
    this.jobTypesAccepted = const {},
    this.openToNegotiating = false,
    this.reviews = const [],
    this.availability = const [],
    this.ageRanges = const [],
  });
}

class BookingModel {
  final String id;
  final SitterModel sitter;
  final DateTime date;
  final String status;

  const BookingModel({
    required this.id,
    required this.sitter,
    required this.date,
    required this.status,
  });
}

class HomeMockData {
  static const currentUser = (
    name: 'Christie',
    location: 'Nashville, TN',
    avatarUrl: 'assets/images/avatars/avatar_christie.png',
  );

  static const activeBookingSitter = SitterModel(
    id: '1',
    userId: 'u1',
    name: 'Krystina',
    avatarUrl: 'assets/images/avatars/avatar_krystina.png',
    rating: 4.5,
    location: '2 Miles Away', // Display string for UI
    distance: '2 Miles',
    responseRate: 95,
    reliabilityRate: 95,
    experienceYears: 5,
    hourlyRate: 20,
    bio:
        "Hi, I'm Krystina! I'm a reliable and enthusiastic sitter with over 5 years of experience. I have a passion for creating a safe and engaging environment for children of all ages. My background includes caring for infants, toddlers, and school-aged children, sticking to routines, and ensuring that homework and playtimes are balanced. I'm also comfortable with pets and light housekeeping. Let's make your day easier knowing your little ones are in good hands!",
  );

  static final activeBooking = BookingModel(
    id: 'b1',
    sitter: activeBookingSitter,
    date: DateTime(2025, 5, 20),
    status: 'Active',
  );

  static const sittersNearYou = [
    SitterModel(
      id: '2',
      userId: 'u2',
      name: 'Krystina', // Reusing same mock data from design
      avatarUrl: 'assets/images/avatars/avatar_krystina.png',
      rating: 4.5,
      location: '5 Miles away',
      distance: '5 Miles',
      responseRate: 95,
      reliabilityRate: 95,
      experienceYears: 5,
      hourlyRate: 20,
      badges: ['CPR', 'First-aid', 'Special Needs Training'],
      bio:
          "Hi, I'm Krystina! I'm a reliable and enthusiastic sitter with over 5 years of experience. I have a passion for creating a safe and engaging environment for children of all ages. My background includes caring for infants, toddlers, and school-aged children, sticking to routines, and ensuring that homework and playtimes are balanced. I'm also comfortable with pets and light housekeeping. Let's make your day easier knowing your little ones are in good hands!",
    ),
    SitterModel(
      id: '3',
      userId: 'u3',
      name: 'Jessica',
      avatarUrl: 'assets/images/avatars/avatar_jessica.png',
      rating: 4.8,
      location: '3 Miles away',
      distance: '3 Miles',
      responseRate: 98,
      reliabilityRate: 100,
      experienceYears: 7,
      hourlyRate: 25,
      badges: ['CPR', 'Special Needs'],
      bio:
          "Hello! I'm Jessica. I specialize in care for children with special needs and have 7 years of professional experience. I am patient, creative, and love forcing on sensory-friendly activities.",
    ),
  ];

  static const savedSitters = [
    SitterModel(
      id: '1',
      userId: 'u1',
      name: 'Krystina',
      avatarUrl: 'assets/images/sitters/sitter_krystina_feed.png',
      rating: 4.5,
      location: 'Nashville, TN',
      distance: '',
      responseRate: 0,
      reliabilityRate: 0,
      experienceYears: 0,
      hourlyRate: 0,
    ),
    SitterModel(
      id: '4',
      userId: 'u4',
      name: 'Krystina',
      avatarUrl: 'assets/images/sitters/sitter_krystina_feed_2.png',
      rating: 4.5,
      location: 'Nashville, TN',
      distance: '',
      responseRate: 0,
      reliabilityRate: 0,
      experienceYears: 0,
      hourlyRate: 0,
    ),
  ];
}
