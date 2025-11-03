enum Priority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case Priority.low:
        return '낮음';
      case Priority.medium:
        return '보통';
      case Priority.high:
        return '높음';
    }
  }

  int get value {
    switch (this) {
      case Priority.low:
        return 0;
      case Priority.medium:
        return 1;
      case Priority.high:
        return 2;
    }
  }

  static Priority fromValue(int value) {
    switch (value) {
      case 0:
        return Priority.low;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.high;
      default:
        return Priority.medium;
    }
  }
}
