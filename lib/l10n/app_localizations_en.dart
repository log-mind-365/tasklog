// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskLog';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get newTodo => 'New Todo';

  @override
  String get editTodo => 'Edit Todo';

  @override
  String get todoEditSheetTitle => 'Edit todo';

  @override
  String get todoLabelsSectionTitle => 'Labels';

  @override
  String get todoLabelHint => 'Type a label, then add';

  @override
  String get todoLabelAdd => 'Add';

  @override
  String todoLabelsChip(int count) {
    return 'Labels ($count)';
  }

  @override
  String get cardColorTooltip => 'Color';

  @override
  String get cardColorNone => 'None';

  @override
  String get labelSheetTitle => 'Labels';

  @override
  String get labelAddHint => 'Add a new label';

  @override
  String get labelAddButton => 'Add';

  @override
  String get labelDeleteTooltip => 'Delete label';

  @override
  String get labelDeleteConfirm => 'Delete this label?';

  @override
  String get labelSheetEmpty => 'No saved labels yet';

  @override
  String get title => 'Title';

  @override
  String get enterTodoTitle => 'Enter todo title';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get description => 'Description';

  @override
  String get priority => 'Priority';

  @override
  String get dueDate => 'Due Date';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get category => 'Category';

  @override
  String get noCategory => 'No Category';

  @override
  String get cannotLoadCategories => 'Cannot load categories';

  @override
  String get addTodo => 'Add Todo';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get todoAdded => 'Todo added';

  @override
  String get todoUpdated => 'Todo updated';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get noSearchResults => 'No search results';

  @override
  String get noTodos => 'No todos';

  @override
  String get tryDifferentKeyword => 'Try a different keyword';

  @override
  String get settings => 'Settings';

  @override
  String get information => 'Information';

  @override
  String get help => 'Help';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get theme => 'Theme';

  @override
  String get version => 'Version';

  @override
  String get license => 'License';

  @override
  String get viewOpenSourceLicenses => 'View open source licenses';

  @override
  String get ok => 'OK';

  @override
  String get appDescription => 'A simple app to manage todos';

  @override
  String get copyright => '© 2025 TaskLog';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get helpTodoManagement => 'Todo Management';

  @override
  String get helpTodoManagementContent =>
      '• Add Todo: Tap + button to add a new todo\n• Complete Todo: Tap checkbox to mark as complete\n• Filter Todos: Use the filter button to select All/Active/Completed\n• Search: You can search todos in the search bar';

  @override
  String get helpSettings => 'Settings';

  @override
  String get helpSettingsContent =>
      '• Theme: You can choose Light/Dark/System theme\n• Language: Supports Korean/English/Japanese';

  @override
  String get todayCheerMessage => 'Let\'s do this';

  @override
  String get searchTodos => 'Search todos...';

  @override
  String get addNewTodo => 'Add a todo to get started';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get selectFilter => 'Select Filter';

  @override
  String get descriptionHint => 'Enter details (optional)';

  @override
  String dueDateFormat(int year, int month, int day) {
    return '$month/$day/$year';
  }

  @override
  String todoDeletedMessage(String title) {
    return '$title deleted';
  }

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get filterTodos => 'Filter Todos';

  @override
  String get allTodos => 'All Todos';

  @override
  String get incompleteTodos => 'Incomplete Todos';

  @override
  String get completedTodos => 'Completed Todos';

  @override
  String get folder => 'Folder';

  @override
  String get folderManagement => 'Manage Folders';

  @override
  String get noFolders => 'No folders yet';

  @override
  String get newFolder => 'New Folder';

  @override
  String get editFolder => 'Edit Folder';

  @override
  String get folderNameLabel => 'Folder Name';

  @override
  String get enterFolderName => 'Enter folder name';

  @override
  String get pleaseEnterFolderName => 'Please enter a folder name';

  @override
  String get selectColor => 'Select Color';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get folderAdded => 'Folder added';

  @override
  String get folderUpdated => 'Folder updated';

  @override
  String get folderDeleted => 'Folder deleted';

  @override
  String get deleteFolderTitle => 'Delete Folder';

  @override
  String deleteFolderConfirm(String folderName) {
    return 'Delete \"$folderName\"?\nTodos in this folder will move to All.';
  }

  @override
  String get todoComposerHint => 'What needs to be done?';

  @override
  String get dueToday => 'Today';

  @override
  String get dueTomorrow => 'Tomorrow';

  @override
  String get clearDueDate => 'Clear due date';

  @override
  String get pickDueDate => 'Pick a date';

  @override
  String get addDescription => 'Add a description';

  @override
  String get noFolder => 'No folder';
}
