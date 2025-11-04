import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/app_drawer.dart';
import 'habits_page.dart';
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
            endDrawer: const AppDrawer(),
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
}
