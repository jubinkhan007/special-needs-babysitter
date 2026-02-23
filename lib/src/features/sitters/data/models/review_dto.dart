import 'package:json_annotation/json_annotation.dart';

part 'review_dto.g.dart';

@JsonSerializable()
class ReviewResponseDto {
  final bool success;
  final List<ReviewDto> data;

  ReviewResponseDto({
    required this.success,
    required this.data,
  });

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewResponseDtoToJson(this);
}

@JsonSerializable()
class ReviewDto {
  @JsonKey(name: '_id')
  final String id;
  final String jobId;
  final ReviewerDto? reviewer;
  final RevieweeDto? reviewee;
  final String reviewerRole;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double rating;
  final String reviewText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewDto({
    required this.id,
    required this.jobId,
    this.reviewer,
    this.reviewee,
    required this.reviewerRole,
    required this.rating,
    required this.reviewText,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDtoToJson(this);
}

@JsonSerializable()
class ReviewerDto {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? role;

  ReviewerDto({
    required this.id,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.role,
  });

  factory ReviewerDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewerDtoToJson(this);

  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) return 'Anonymous';
    return '$first $last'.trim();
  }
}

@JsonSerializable()
class RevieweeDto {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? role;

  RevieweeDto({
    required this.id,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.role,
  });

  factory RevieweeDto.fromJson(Map<String, dynamic> json) =>
      _$RevieweeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RevieweeDtoToJson(this);

  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) return 'Unknown';
    return '$first $last'.trim();
  }
}

/// Parses a double that might come as a String or int from the API
double _parseDoubleFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
