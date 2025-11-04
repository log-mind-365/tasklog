import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/app_drawer.dart';
import 'habits_page.dart';
import 'settings_page.dart';
import 'todos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use NavigationRail for wider screens (desktop)
        final useRail = constraints.maxWidth >= 600;

        if (useRail) {
          return Scaffold(
            key: _scaffoldKey,
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.check_circle_outline),
                      selectedIcon: const Icon(Icons.check_circle),
                      label: Text(l10n.navTodos),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.track_changes_outlined),
                      selectedIcon: const Icon(Icons.track_changes),
                      label: Text(l10n.navHabits),
                    ),
                  ],
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              tooltip: l10n.settings,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.help_outline),
                              tooltip: l10n.help,
                              onPressed: () => _showHelpDialog(context),
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              tooltip: l10n.information,
                              onPressed: () => _showAboutDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      TodosPage(scaffoldKey: _scaffoldKey),
                      HabitsPage(scaffoldKey: _scaffoldKey),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Use BottomNavigationBar for narrow screens (mobile)
          return Scaffold(
            key: _scaffoldKey,
            endDrawer: const AppDrawer(),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                TodosPage(scaffoldKey: _scaffoldKey),
                HabitsPage(scaffoldKey: _scaffoldKey),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.check_circle_outline),
                  selectedIcon: const Icon(Icons.check_circle),
                  label: l10n.navTodos,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.track_changes_outlined),
                  selectedIcon: const Icon(Icons.track_changes),
                  label: l10n.navHabits,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (Platform.isMacOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(l10n.help),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingMedium),
                _buildHelpSection(
                  context,
                  l10n.helpTodoManagement,
                  l10n.helpTodoManagementContent,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildHelpSection(
                  context,
                  l10n.helpHabitTracking,
                  l10n.helpHabitTrackingContent,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildHelpSection(
                  context,
                  l10n.helpSettings,
                  l10n.helpSettingsContent,
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    } else {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: theme.colorScheme.primary,
                size: AppConstants.iconSizeLarge,
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(l10n.help),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHelpSection(
                  context,
                  l10n.helpTodoManagement,
                  l10n.helpTodoManagementContent,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildHelpSection(
                  context,
                  l10n.helpHabitTracking,
                  l10n.helpHabitTrackingContent,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildHelpSection(
                  context,
                  l10n.helpSettings,
                  l10n.helpSettingsContent,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildHelpSection(BuildContext context, String title, String content) {
    if (Platform.isMacOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            content,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
            ),
          ),
        ],
      );
    } else {
      final theme = Theme.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (Platform.isMacOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(l10n.appTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                '${l10n.version} 1.0.0',
                style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              Text(
                l10n.appDescription,
                style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
              ),
              const SizedBox(height: AppConstants.spacingXXLarge),
              Text(
                l10n.copyright,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXSmall,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    } else {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.task_alt,
                color: theme.colorScheme.primary,
                size: AppConstants.iconSizeLarge,
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(l10n.appTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.version} 1.0.0',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              Text(
                l10n.appDescription,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.spacingXXLarge),
              Text(
                l10n.copyright,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: AppConstants.alphaStrong,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }
}
