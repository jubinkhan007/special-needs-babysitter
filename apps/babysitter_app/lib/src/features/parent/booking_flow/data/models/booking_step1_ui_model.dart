import 'child_ui_model.dart';

class BookingStep1UiModel {
  final List<ChildUiModel> children;
  final String additionalDetailsText;
  final String payRateText;

  const BookingStep1UiModel({
    required this.children,
    this.additionalDetailsText = '',
    this.payRateText = '',
  });

  BookingStep1UiModel copyWith({
    List<ChildUiModel>? children,
    String? additionalDetailsText,
    String? payRateText,
  }) {
    return BookingStep1UiModel(
      children: children ?? this.children,
      additionalDetailsText:
          additionalDetailsText ?? this.additionalDetailsText,
      payRateText: payRateText ?? this.payRateText,
    );
  }
}
