class RouteStopUiModel {
  final String addressLine;
  final String timeLabel;
  final bool isActive;
  final bool isLast;

  const RouteStopUiModel({
    required this.addressLine,
    required this.timeLabel,
    this.isActive = false,
    this.isLast = false,
  });
}
