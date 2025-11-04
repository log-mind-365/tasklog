import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// 애플리케이션 제목
  ///
  /// In ko, this message translates to:
  /// **'TaskLog'**
  String get appTitle;

  /// 할일 탭 레이블
  ///
  /// In ko, this message translates to:
  /// **'할일'**
  String get navTodos;

  /// 습관 탭 레이블
  ///
  /// In ko, this message translates to:
  /// **'습관'**
  String get navHabits;

  /// 습관 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'습관'**
  String get habitsPageTitle;

  /// 습관이 없을 때 표시되는 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 습관이 없습니다'**
  String get noHabitsYet;

  /// 새 습관 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 습관'**
  String get newHabit;

  /// 습관 수정 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'습관 수정'**
  String get editHabit;

  /// 습관 이름 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'습관 이름'**
  String get habitName;

  /// 일일 목표 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'일일 목표'**
  String get dailyGoal;

  /// 아이콘 선택 섹션
  ///
  /// In ko, this message translates to:
  /// **'아이콘 선택'**
  String get selectIcon;

  /// 색상 선택 섹션
  ///
  /// In ko, this message translates to:
  /// **'색상 선택'**
  String get selectColor;

  /// 습관 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'습관 생성'**
  String get createHabit;

  /// 습관 수정 버튼
  ///
  /// In ko, this message translates to:
  /// **'습관 수정'**
  String get updateHabit;

  /// 습관 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'습관 삭제'**
  String get deleteHabit;

  /// 습관 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'\"{habitName}\"을(를) 삭제하시겠습니까?'**
  String deleteHabitConfirm(String habitName);

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// 습관 생성 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'습관이 생성되었습니다'**
  String get habitCreated;

  /// 습관 수정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'습관이 수정되었습니다'**
  String get habitUpdated;

  /// 기본 정보 섹션
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get basicInformation;

  /// 외형 섹션
  ///
  /// In ko, this message translates to:
  /// **'외형'**
  String get appearance;

  /// 습관 이름 유효성 검사 오류
  ///
  /// In ko, this message translates to:
  /// **'습관 이름을 입력하세요'**
  String get pleaseEnterHabitName;

  /// 목표 유효성 검사 오류
  ///
  /// In ko, this message translates to:
  /// **'목표를 입력하세요'**
  String get pleaseEnterGoal;

  /// 목표 최소값 유효성 검사 오류
  ///
  /// In ko, this message translates to:
  /// **'목표는 최소 1 이상이어야 합니다'**
  String get goalMustBeAtLeast1;

  /// 통계 섹션
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get statistics;

  /// 완료율 레이블
  ///
  /// In ko, this message translates to:
  /// **'완료율'**
  String get completionRate;

  /// 전체 횟수 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 횟수'**
  String get totalCount;

  /// 현재 연속 기록 레이블
  ///
  /// In ko, this message translates to:
  /// **'현재 연속 기록'**
  String get currentStreak;

  /// 최장 연속 기록 레이블
  ///
  /// In ko, this message translates to:
  /// **'최장 연속 기록'**
  String get longestStreak;

  /// 활동 히트맵 섹션
  ///
  /// In ko, this message translates to:
  /// **'활동 히트맵'**
  String get activityHeatmap;

  /// 새 할일 추가 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'새 할일'**
  String get newTodo;

  /// 할일 수정 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'할일 수정'**
  String get editTodo;

  /// 제목 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get title;

  /// 할일 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'할일 제목을 입력하세요'**
  String get enterTodoTitle;

  /// 제목 유효성 검사 오류
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력하세요'**
  String get pleaseEnterTitle;

  /// 설명 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get description;

  /// 우선순위 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'우선순위'**
  String get priority;

  /// 마감일 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'마감일'**
  String get dueDate;

  /// 마감일 선택 힌트
  ///
  /// In ko, this message translates to:
  /// **'마감일을 선택하세요'**
  String get selectDueDate;

  /// 카테고리 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get category;

  /// 카테고리 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'카테고리 없음'**
  String get noCategory;

  /// 카테고리 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 불러올 수 없습니다'**
  String get cannotLoadCategories;

  /// 할일 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'할일 추가'**
  String get addTodo;

  /// 변경사항 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'변경사항 저장'**
  String get saveChanges;

  /// 할일 추가 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'할일이 추가되었습니다'**
  String get todoAdded;

  /// 할일 수정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'할일이 수정되었습니다'**
  String get todoUpdated;

  /// 전체 필터
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get filterAll;

  /// 미완료 필터
  ///
  /// In ko, this message translates to:
  /// **'미완료'**
  String get filterActive;

  /// 완료 필터
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get filterCompleted;

  /// 검색 결과 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get noSearchResults;

  /// 할일 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'할일이 없습니다'**
  String get noTodos;

  /// 검색 결과 없음 힌트
  ///
  /// In ko, this message translates to:
  /// **'다른 키워드로 검색해보세요'**
  String get tryDifferentKeyword;

  /// 설정 메뉴
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 정보 메뉴
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get information;

  /// 도움말 메뉴
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get help;

  /// 언어 설정 메뉴
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettings;

  /// 테마 메뉴
  ///
  /// In ko, this message translates to:
  /// **'테마'**
  String get theme;

  /// 버전 레이블
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// 라이선스 레이블
  ///
  /// In ko, this message translates to:
  /// **'라이선스'**
  String get license;

  /// 오픈소스 라이선스 보기
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스 보기'**
  String get viewOpenSourceLicenses;

  /// 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// 앱 설명
  ///
  /// In ko, this message translates to:
  /// **'할일과 습관을 관리하는 간편한 앱'**
  String get appDescription;

  /// 저작권 정보
  ///
  /// In ko, this message translates to:
  /// **'© 2025 TaskLog'**
  String get copyright;

  /// 언어 선택 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get selectLanguage;

  /// 테마 선택 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'테마 선택'**
  String get selectTheme;

  /// 시스템 설정 옵션
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get systemSettings;

  /// 한국어
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// 영어
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// 일본어
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// 라이트 테마
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get light;

  /// 다크 테마
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get dark;

  /// 언어 레이블
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// 도움말 - 할일 관리 제목
  ///
  /// In ko, this message translates to:
  /// **'할일 관리'**
  String get helpTodoManagement;

  /// 도움말 - 할일 관리 내용
  ///
  /// In ko, this message translates to:
  /// **'• 할일 추가: + 버튼을 눌러 새로운 할일을 추가하세요\n• 할일 완료: 체크박스를 눌러 완료 처리하세요\n• 할일 필터: 상단 필터 버튼으로 전체/미완료/완료를 선택하세요\n• 검색: 검색창에서 할일을 검색할 수 있습니다'**
  String get helpTodoManagementContent;

  /// 도움말 - 습관 추적 제목
  ///
  /// In ko, this message translates to:
  /// **'습관 추적'**
  String get helpHabitTracking;

  /// 도움말 - 습관 추적 내용
  ///
  /// In ko, this message translates to:
  /// **'• 습관 추가: + 버튼을 눌러 새로운 습관을 만드세요\n• 일일 목표: 각 습관의 일일 목표를 설정할 수 있습니다\n• 기록: +/- 버튼으로 습관 실행을 기록하세요\n• 통계: 습관을 터치하면 상세 통계를 볼 수 있습니다'**
  String get helpHabitTrackingContent;

  /// 도움말 - 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get helpSettings;

  /// 도움말 - 설정 내용
  ///
  /// In ko, this message translates to:
  /// **'• 테마: 라이트/다크/시스템 테마를 선택할 수 있습니다\n• 언어: 한국어/영어/일본어를 지원합니다'**
  String get helpSettingsContent;

  /// 할일 페이지 응원 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘도 화이팅! 💪'**
  String get todayCheerMessage;

  /// 할일 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'할일 검색...'**
  String get searchTodos;

  /// 할일이 없을 때 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'새로운 할일을 추가해보세요 ✨'**
  String get addNewTodo;

  /// 오류 발생 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get errorOccurred;

  /// 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류 발생: {error}'**
  String errorMessage(String error);

  /// 필터 선택 바텀시트 제목
  ///
  /// In ko, this message translates to:
  /// **'필터 선택'**
  String get selectFilter;

  /// 설명 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'상세 내용을 입력하세요 (선택)'**
  String get descriptionHint;

  /// 마감일 형식
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String dueDateFormat(int year, int month, int day);

  /// 첫 습관 만들기 안내
  ///
  /// In ko, this message translates to:
  /// **'Tap + to create your first habit'**
  String get tapToCreateFirstHabit;

  /// 일 단위
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get days;

  /// 할일 삭제 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'{title} 삭제됨'**
  String todoDeletedMessage(String title);

  /// 낮은 우선순위
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get priorityLow;

  /// 보통 우선순위
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get priorityMedium;

  /// 높은 우선순위
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get priorityHigh;

  /// 습관 삭제 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'{name} 삭제됨'**
  String habitDeletedMessage(String name);

  /// 일일 목표 표시
  ///
  /// In ko, this message translates to:
  /// **'일일 목표: {count}'**
  String dailyGoalWithCount(int count);

  /// 일 수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}일'**
  String daysCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
