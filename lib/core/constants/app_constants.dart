/// UI 관련 상수 정의
class AppConstants {
  AppConstants._();

  // Alpha (투명도) 값
  static const double alphaVeryLight = 0.08;
  static const double alphaLight = 0.1;
  static const double alphaMediumLight = 0.15;
  static const double alphaMedium = 0.2;
  static const double alphaMediumHigh = 0.25;
  static const double alphaHigh = 0.3;
  static const double alphaStrong = 0.5;
  static const double alphaVeryStrong = 0.6;
  static const double alphaIntense = 0.7;
  static const double alphaVeryIntense = 0.75;

  // Border Radius 값
  static const double radiusXSmall = 2.0;
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusXXLarge = 20.0;
  static const double radiusHuge = 24.0;

  // Spacing (Padding/Margin) 값
  static const double spacingXXSmall = 1.0;
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingXXXLarge = 40.0;
  static const double spacingHuge = 32.0;
  static const double spacingXHuge = 48.0;
  static const double spacingXXHuge = 64.0;
  static const double spacingGiant = 56.0;
  static const double spacingXGiant = 80.0;
  static const double spacingXXGiant = 84.0;
  static const double spacingMassive = 120.0;

  // Elevation 값
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 12.0;

  // Icon Size 값
  static const double iconSizeXSmall = 14.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 28.0;
  static const double iconSizeXXLarge = 40.0;
  static const double iconSizeHuge = 48.0;
  static const double iconSizeXHuge = 64.0;

  // Font Size 값
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeHuge = 24.0;
  static const double fontSizeXHuge = 28.0;
  static const double fontSizeXXHuge = 32.0;

  // Border Width 값
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // 기타 크기 값
  static const double cellSize = 14.0;
  static const double dividerHeight = 32.0;
  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;

  // Duration 값 (milliseconds)
  static const int durationShort = 150;
  static const int durationNormal = 300;
  static const int durationLong = 500;

  // 일수 값
  static const int defaultWeeksToShow = 12;
  static const int daysPerWeek = 7;
  static const int defaultHistoryDays = 84; // 12 weeks
}

/// UI 색상 팔레트 및 아이콘 상수
class AppPalette {
  AppPalette._();

  /// 공통 색상 팔레트 (폴더, 습관 등에 사용)
  static const List<int> colorValues = [
    0xFFFF0000, // Colors.red
    0xFFE91E63, // Colors.pink
    0xFF9C27B0, // Colors.purple
    0xFF673AB7, // Colors.deepPurple
    0xFF3F51B5, // Colors.indigo
    0xFF2196F3, // Colors.blue
    0xFF03A9F4, // Colors.lightBlue
    0xFF00BCD4, // Colors.cyan
    0xFF009688, // Colors.teal
    0xFF4CAF50, // Colors.green
    0xFF8BC34A, // Colors.lightGreen
    0xFFCDDC39, // Colors.lime
    0xFFFFEB3B, // Colors.yellow
    0xFFFFC107, // Colors.amber
    0xFFFF9800, // Colors.orange
    0xFFFF5722, // Colors.deepOrange
    0xFF795548, // Colors.brown
  ];

  /// 습관 아이콘 팔레트
  static const List<String> habitIcons = [
    '💧',
    '🏃',
    '📚',
    '🧘',
    '🎯',
    '✍️',
    '🎨',
    '🎵',
    '💪',
    '🍎',
    '😴',
    '🧠',
    '📝',
    '🌱',
    '☕',
    '🚶',
  ];
}
