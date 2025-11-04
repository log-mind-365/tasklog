// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'TaskLog';

  @override
  String get navTodos => '할일';

  @override
  String get navHabits => '습관';

  @override
  String get habitsPageTitle => '습관';

  @override
  String get noHabitsYet => '아직 습관이 없습니다';

  @override
  String get newHabit => '새 습관';

  @override
  String get editHabit => '습관 수정';

  @override
  String get habitName => '습관 이름';

  @override
  String get dailyGoal => '일일 목표';

  @override
  String get selectIcon => '아이콘 선택';

  @override
  String get selectColor => '색상 선택';

  @override
  String get createHabit => '습관 생성';

  @override
  String get updateHabit => '습관 수정';

  @override
  String get deleteHabit => '습관 삭제';

  @override
  String deleteHabitConfirm(String habitName) {
    return '\"$habitName\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get habitCreated => '습관이 생성되었습니다';

  @override
  String get habitUpdated => '습관이 수정되었습니다';

  @override
  String get basicInformation => '기본 정보';

  @override
  String get appearance => '외형';

  @override
  String get pleaseEnterHabitName => '습관 이름을 입력하세요';

  @override
  String get pleaseEnterGoal => '목표를 입력하세요';

  @override
  String get goalMustBeAtLeast1 => '목표는 최소 1 이상이어야 합니다';

  @override
  String get statistics => '통계';

  @override
  String get completionRate => '완료율';

  @override
  String get totalCount => '전체 횟수';

  @override
  String get currentStreak => '현재 연속 기록';

  @override
  String get longestStreak => '최장 연속 기록';

  @override
  String get activityHeatmap => '활동 히트맵';

  @override
  String get newTodo => '새 할일';

  @override
  String get editTodo => '할일 수정';

  @override
  String get title => '제목';

  @override
  String get enterTodoTitle => '할일 제목을 입력하세요';

  @override
  String get pleaseEnterTitle => '제목을 입력하세요';

  @override
  String get description => '설명';

  @override
  String get priority => '우선순위';

  @override
  String get dueDate => '마감일';

  @override
  String get selectDueDate => '마감일을 선택하세요';

  @override
  String get category => '카테고리';

  @override
  String get noCategory => '카테고리 없음';

  @override
  String get cannotLoadCategories => '카테고리를 불러올 수 없습니다';

  @override
  String get addTodo => '할일 추가';

  @override
  String get saveChanges => '변경사항 저장';

  @override
  String get todoAdded => '할일이 추가되었습니다';

  @override
  String get todoUpdated => '할일이 수정되었습니다';

  @override
  String get filterAll => '전체';

  @override
  String get filterActive => '미완료';

  @override
  String get filterCompleted => '완료';

  @override
  String get noSearchResults => '검색 결과가 없습니다';

  @override
  String get noTodos => '할일이 없습니다';

  @override
  String get tryDifferentKeyword => '다른 키워드로 검색해보세요';

  @override
  String get settings => '설정';

  @override
  String get information => '정보';

  @override
  String get help => '도움말';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get theme => '테마';

  @override
  String get version => '버전';

  @override
  String get license => '라이선스';

  @override
  String get viewOpenSourceLicenses => '오픈소스 라이선스 보기';

  @override
  String get ok => '확인';

  @override
  String get appDescription => '할일과 습관을 관리하는 간편한 앱';

  @override
  String get copyright => '© 2025 TaskLog';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get selectTheme => '테마 선택';

  @override
  String get systemSettings => '시스템 설정';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get language => '언어';

  @override
  String get helpTodoManagement => '할일 관리';

  @override
  String get helpTodoManagementContent =>
      '• 할일 추가: + 버튼을 눌러 새로운 할일을 추가하세요\n• 할일 완료: 체크박스를 눌러 완료 처리하세요\n• 할일 필터: 상단 필터 버튼으로 전체/미완료/완료를 선택하세요\n• 검색: 검색창에서 할일을 검색할 수 있습니다';

  @override
  String get helpHabitTracking => '습관 추적';

  @override
  String get helpHabitTrackingContent =>
      '• 습관 추가: + 버튼을 눌러 새로운 습관을 만드세요\n• 일일 목표: 각 습관의 일일 목표를 설정할 수 있습니다\n• 기록: +/- 버튼으로 습관 실행을 기록하세요\n• 통계: 습관을 터치하면 상세 통계를 볼 수 있습니다';

  @override
  String get helpSettings => '설정';

  @override
  String get helpSettingsContent =>
      '• 테마: 라이트/다크/시스템 테마를 선택할 수 있습니다\n• 언어: 한국어/영어/일본어를 지원합니다';

  @override
  String get todayCheerMessage => '오늘도 화이팅! 💪';

  @override
  String get searchTodos => '할일 검색...';

  @override
  String get addNewTodo => '새로운 할일을 추가해보세요 ✨';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String errorMessage(String error) {
    return '오류 발생: $error';
  }

  @override
  String get selectFilter => '필터 선택';

  @override
  String get descriptionHint => '상세 내용을 입력하세요 (선택)';

  @override
  String dueDateFormat(int year, int month, int day) {
    return '$year년 $month월 $day일';
  }

  @override
  String get tapToCreateFirstHabit => 'Tap + to create your first habit';

  @override
  String get days => '일';

  @override
  String todoDeletedMessage(String title) {
    return '$title 삭제됨';
  }

  @override
  String get priorityLow => '낮음';

  @override
  String get priorityMedium => '보통';

  @override
  String get priorityHigh => '높음';

  @override
  String habitDeletedMessage(String name) {
    return '$name 삭제됨';
  }

  @override
  String dailyGoalWithCount(int count) {
    return '일일 목표: $count';
  }

  @override
  String daysCount(int count) {
    return '$count일';
  }
}
