enum Category {
  travel,
  food,
  utilities,
  housing,
  shopping,
  entertainment,
  education,
  work;

  String get displayName {
    switch (this) {
      case Category.travel:
        return 'Travel';
      case Category.food:
        return 'Food';
      case Category.utilities:
        return 'Utilities';
      case Category.housing:
        return 'Housing';
      case Category.shopping:
        return 'Shopping';
      case Category.entertainment:
        return 'Entertainment';
      case Category.education:
        return 'Education';
      case Category.work:
        return 'Work';
    }
  }

  static Category fromString(String value) {
    return Category.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw FormatException('Unknown category: $value'),
    );
  }
}
