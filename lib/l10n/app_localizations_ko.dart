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
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get newTodo => '새 할일';

  @override
  String get editTodo => '할일 수정';

  @override
  String get todoEditSheetTitle => '할 일 편집';

  @override
  String get todoLabelsSectionTitle => '라벨';

  @override
  String get todoLabelHint => '라벨 입력 후 추가';

  @override
  String get todoLabelAdd => '추가';

  @override
  String todoLabelsChip(int count) {
    return '라벨 $count개';
  }

  @override
  String get cardColorTooltip => '색상';

  @override
  String get cardColorNone => '없음';

  @override
  String get labelSheetTitle => '라벨';

  @override
  String get labelAddHint => '새 라벨 입력';

  @override
  String get labelAddButton => '추가';

  @override
  String get labelDeleteTooltip => '라벨 삭제';

  @override
  String get labelDeleteConfirm => '이 라벨을 삭제할까요?';

  @override
  String get labelSheetEmpty => '저장된 라벨이 없습니다';

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
  String get appDescription => '할일을 관리하는 간편한 앱';

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
  String get helpSettings => '설정';

  @override
  String get helpSettingsContent =>
      '• 테마: 라이트/다크/시스템 테마를 선택할 수 있습니다\n• 언어: 한국어/영어/일본어를 지원합니다';

  @override
  String get todayCheerMessage => '오늘도 화이팅';

  @override
  String get searchTodos => '할일 검색...';

  @override
  String get addNewTodo => '할 일을 추가해 보세요';

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
  String get filterTodos => '할일 필터';

  @override
  String get allTodos => '전체 할일';

  @override
  String get incompleteTodos => '미완료 할일';

  @override
  String get completedTodos => '완료된 할일';

  @override
  String get folder => '폴더';

  @override
  String get folderManagement => '폴더 관리';

  @override
  String get noFolders => '폴더가 없습니다';

  @override
  String get newFolder => '새 폴더';

  @override
  String get editFolder => '폴더 편집';

  @override
  String get folderNameLabel => '폴더 이름';

  @override
  String get enterFolderName => '폴더 이름을 입력하세요';

  @override
  String get pleaseEnterFolderName => '폴더 이름을 입력하세요';

  @override
  String get selectColor => '색상 선택';

  @override
  String get add => '추가';

  @override
  String get edit => '편집';

  @override
  String get folderAdded => '폴더가 추가되었습니다';

  @override
  String get folderUpdated => '폴더가 수정되었습니다';

  @override
  String get folderDeleted => '폴더가 삭제되었습니다';

  @override
  String get deleteFolderTitle => '폴더 삭제';

  @override
  String deleteFolderConfirm(String folderName) {
    return '$folderName 폴더를 삭제하시겠습니까?\n이 폴더의 할일들은 \"전체\"로 이동됩니다.';
  }

  @override
  String get todoComposerHint => '할 일을 입력하세요';

  @override
  String get dueToday => '오늘';

  @override
  String get dueTomorrow => '내일';

  @override
  String get clearDueDate => '마감일 제거';

  @override
  String get pickDueDate => '날짜 선택';

  @override
  String get addDescription => '설명을 입력하세요';

  @override
  String get noFolder => '폴더 없음';
}
