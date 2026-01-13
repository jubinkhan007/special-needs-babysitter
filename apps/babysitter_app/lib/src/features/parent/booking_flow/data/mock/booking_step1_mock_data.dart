import '../models/child_ui_model.dart';
import '../models/booking_step1_ui_model.dart';

class BookingStep1MockData {
  static const List<ChildUiModel> children = [
    ChildUiModel(
      id: '1',
      name: 'Margaret',
      ageText: '(3 Years old)',
      isSelected: true,
    ),
    ChildUiModel(
      id: '2',
      name: 'Cindy',
      ageText: '(2 Years old)',
      isSelected: false,
    ),
    ChildUiModel(
      id: '3',
      name: 'Lola',
      ageText: '(6 Months old)',
      isSelected: false,
    ),
  ];

  static const BookingStep1UiModel initialData = BookingStep1UiModel(
    children: children,
    payRateText: '\$ 20/hr',
  );
}
