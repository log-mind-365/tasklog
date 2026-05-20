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
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

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
  String get appDescription => 'タスクを管理するシンプルなアプリ';

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
  String get helpSettings => '設定';

  @override
  String get helpSettingsContent =>
      '• テーマ: ライト/ダーク/システム設定のテーマを選択できます\n• 言語: 韓国語/英語/日本語をサポートしています';

  @override
  String get todayCheerMessage => '今日も頑張りましょう';

  @override
  String get searchTodos => 'タスクを検索...';

  @override
  String get addNewTodo => 'タスクを追加してみましょう';

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
  String get filterTodos => 'タスクフィルター';

  @override
  String get allTodos => '全てのタスク';

  @override
  String get incompleteTodos => '未完了のタスク';

  @override
  String get completedTodos => '完了したタスク';

  @override
  String get folder => 'フォルダー';

  @override
  String get folderManagement => 'フォルダー管理';

  @override
  String get noFolders => 'フォルダーがありません';

  @override
  String get newFolder => '新しいフォルダー';

  @override
  String get editFolder => 'フォルダーを編集';

  @override
  String get folderNameLabel => 'フォルダー名';

  @override
  String get enterFolderName => 'フォルダー名を入力してください';

  @override
  String get pleaseEnterFolderName => 'フォルダー名を入力してください';

  @override
  String get selectColor => '色を選択';

  @override
  String get add => '追加';

  @override
  String get edit => '編集';

  @override
  String get folderAdded => 'フォルダーが追加されました';

  @override
  String get folderUpdated => 'フォルダーが更新されました';

  @override
  String get folderDeleted => 'フォルダーが削除されました';

  @override
  String get deleteFolderTitle => 'フォルダーを削除';

  @override
  String deleteFolderConfirm(String folderName) {
    return '「$folderName」を削除しますか？\nこのフォルダーのタスクは「すべて」に移動されます。';
  }

  @override
  String get todoComposerHint => 'タスクを入力してください';

  @override
  String get dueToday => '今日';

  @override
  String get dueTomorrow => '明日';

  @override
  String get clearDueDate => '期限を削除';

  @override
  String get pickDueDate => '日付を選択';

  @override
  String get addDescription => '説明を入力してください';

  @override
  String get noFolder => 'フォルダーなし';
}
