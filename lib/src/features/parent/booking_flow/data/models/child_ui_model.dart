class ChildUiModel {
  final String id;
  final String name;
  final String ageText;
  final bool isSelected;

  const ChildUiModel({
    required this.id,
    required this.name,
    required this.ageText,
    this.isSelected = false,
  });

  ChildUiModel copyWith({
    String? id,
    String? name,
    String? ageText,
    bool? isSelected,
  }) {
    return ChildUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ageText: ageText ?? this.ageText,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
