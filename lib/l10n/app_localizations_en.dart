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
  String get navTodos => 'Todos';

  @override
  String get navHabits => 'Habits';

  @override
  String get habitsPageTitle => 'Habits';

  @override
  String get noHabitsYet => 'No habits yet';

  @override
  String get newHabit => 'New Habit';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get habitName => 'Habit Name';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get selectColor => 'Select Color';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get updateHabit => 'Update Habit';

  @override
  String get deleteHabit => 'Delete Habit';

  @override
  String deleteHabitConfirm(String habitName) {
    return 'Are you sure you want to delete \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get habitCreated => 'Habit created';

  @override
  String get habitUpdated => 'Habit updated';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get appearance => 'Appearance';

  @override
  String get pleaseEnterHabitName => 'Please enter a habit name';

  @override
  String get pleaseEnterGoal => 'Please enter a goal';

  @override
  String get goalMustBeAtLeast1 => 'Goal must be at least 1';

  @override
  String get statistics => 'Statistics';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get totalCount => 'Total Count';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get activityHeatmap => 'Activity Heatmap';

  @override
  String get newTodo => 'New Todo';

  @override
  String get editTodo => 'Edit Todo';

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
  String get appDescription => 'A simple app to manage todos and habits';

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
  String get helpHabitTracking => 'Habit Tracking';

  @override
  String get helpHabitTrackingContent =>
      '• Add Habit: Tap + button to create a new habit\n• Daily Goal: You can set a daily goal for each habit\n• Record: Use +/- buttons to record habit completion\n• Statistics: Tap on a habit to view detailed statistics';

  @override
  String get helpSettings => 'Settings';

  @override
  String get helpSettingsContent =>
      '• Theme: You can choose Light/Dark/System theme\n• Language: Supports Korean/English/Japanese';

  @override
  String get todayCheerMessage => 'Let\'s do this! 💪';

  @override
  String get searchTodos => 'Search todos...';

  @override
  String get addNewTodo => 'Add your first todo ✨';

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
  String get tapToCreateFirstHabit => 'Tap + to create your first habit';

  @override
  String get days => 'days';

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
  String habitDeletedMessage(String name) {
    return '$name deleted';
  }

  @override
  String dailyGoalWithCount(int count) {
    return 'Daily Goal: $count';
  }

  @override
  String daysCount(int count) {
    return '$count days';
  }
}
