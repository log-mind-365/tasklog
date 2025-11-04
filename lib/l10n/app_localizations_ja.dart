// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'TaskLog';

  @override
  String get navTodos => 'タスク';

  @override
  String get navHabits => '習慣';

  @override
  String get habitsPageTitle => '習慣';

  @override
  String get noHabitsYet => 'まだ習慣がありません';

  @override
  String get newHabit => '新しい習慣';

  @override
  String get editHabit => '習慣を編集';

  @override
  String get habitName => '習慣名';

  @override
  String get dailyGoal => '1日の目標';

  @override
  String get selectIcon => 'アイコンを選択';

  @override
  String get selectColor => '色を選択';

  @override
  String get createHabit => '習慣を作成';

  @override
  String get updateHabit => '習慣を更新';

  @override
  String get deleteHabit => '習慣を削除';

  @override
  String deleteHabitConfirm(String habitName) {
    return '「$habitName」を削除してもよろしいですか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get habitCreated => '習慣が作成されました';

  @override
  String get habitUpdated => '習慣が更新されました';

  @override
  String get basicInformation => '基本情報';

  @override
  String get appearance => '外観';

  @override
  String get pleaseEnterHabitName => '習慣名を入力してください';

  @override
  String get pleaseEnterGoal => '目標を入力してください';

  @override
  String get goalMustBeAtLeast1 => '目標は1以上である必要があります';

  @override
  String get statistics => '統計';

  @override
  String get completionRate => '完了率';

  @override
  String get totalCount => '合計回数';

  @override
  String get currentStreak => '現在の連続記録';

  @override
  String get longestStreak => '最長連続記録';

  @override
  String get activityHeatmap => 'アクティビティヒートマップ';

  @override
  String get newTodo => '新しいタスク';

  @override
  String get editTodo => 'タスクを編集';

  @override
  String get title => 'タイトル';

  @override
  String get enterTodoTitle => 'タスクのタイトルを入力してください';

  @override
  String get pleaseEnterTitle => 'タイトルを入力してください';

  @override
  String get description => '説明';

  @override
  String get priority => '優先度';

  @override
  String get dueDate => '期限';

  @override
  String get selectDueDate => '期限を選択してください';

  @override
  String get category => 'カテゴリー';

  @override
  String get noCategory => 'カテゴリーなし';

  @override
  String get cannotLoadCategories => 'カテゴリーを読み込めません';

  @override
  String get addTodo => 'タスクを追加';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get todoAdded => 'タスクが追加されました';

  @override
  String get todoUpdated => 'タスクが更新されました';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterActive => '未完了';

  @override
  String get filterCompleted => '完了';

  @override
  String get noSearchResults => '検索結果がありません';

  @override
  String get noTodos => 'タスクがありません';

  @override
  String get tryDifferentKeyword => '別のキーワードで検索してください';

  @override
  String get settings => '設定';

  @override
  String get information => '情報';

  @override
  String get help => 'ヘルプ';

  @override
  String get languageSettings => '言語設定';

  @override
  String get theme => 'テーマ';

  @override
  String get version => 'バージョン';

  @override
  String get license => 'ライセンス';

  @override
  String get viewOpenSourceLicenses => 'オープンソースライセンスを表示';

  @override
  String get ok => 'OK';

  @override
  String get appDescription => 'タスクと習慣を管理するシンプルなアプリ';

  @override
  String get copyright => '© 2025 TaskLog';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get selectTheme => 'テーマを選択';

  @override
  String get systemSettings => 'システム設定';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get helpTodoManagement => 'タスク管理';

  @override
  String get helpTodoManagementContent =>
      '• タスク追加: +ボタンをタップして新しいタスクを追加します\n• タスク完了: チェックボックスをタップして完了にします\n• タスクフィルター: フィルターボタンで全て/未完了/完了を選択します\n• 検索: 検索バーでタスクを検索できます';

  @override
  String get helpHabitTracking => '習慣追跡';

  @override
  String get helpHabitTrackingContent =>
      '• 習慣追加: +ボタンをタップして新しい習慣を作成します\n• 1日の目標: 各習慣の1日の目標を設定できます\n• 記録: +/-ボタンで習慣の実行を記録します\n• 統計: 習慣をタップすると詳細な統計が表示されます';

  @override
  String get helpSettings => '設定';

  @override
  String get helpSettingsContent =>
      '• テーマ: ライト/ダーク/システム設定のテーマを選択できます\n• 言語: 韓国語/英語/日本語をサポートしています';

  @override
  String get todayCheerMessage => '今日も頑張りましょう! 💪';

  @override
  String get searchTodos => 'タスクを検索...';

  @override
  String get addNewTodo => '最初のタスクを追加してください ✨';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String errorMessage(String error) {
    return 'エラー: $error';
  }

  @override
  String get selectFilter => 'フィルターを選択';

  @override
  String get descriptionHint => '詳細を入力してください（任意）';

  @override
  String dueDateFormat(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get tapToCreateFirstHabit => 'Tap + to create your first habit';

  @override
  String get days => '日';

  @override
  String todoDeletedMessage(String title) {
    return '$title 削除されました';
  }

  @override
  String get priorityLow => '低';

  @override
  String get priorityMedium => '中';

  @override
  String get priorityHigh => '高';

  @override
  String habitDeletedMessage(String name) {
    return '$name 削除されました';
  }

  @override
  String dailyGoalWithCount(int count) {
    return '1日の目標: $count';
  }

  @override
  String daysCount(int count) {
    return '$count日';
  }
}
