import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:quickstart/pages/task_list_page.dart";
import "package:quickstart/widgets/add_task_widget.dart";
import "package:quickstart/widgets/default_colors.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const PersistenBottomNavBarDemo());
}

class PersistenBottomNavBarDemo extends StatelessWidget {
  const PersistenBottomNavBarDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Persistent Bottom Navigation Bar Demo",
    home: Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/minimal"),
              child: const Text("Show Minimal Example"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed("/interactive"),
              child: const Text("Show Interactive Example"),
            ),
          ],
        ),
      ),
    ),
    routes: {
      "/minimal": (context) => const MinimalExample(),
      "/interactive": (context) => const TaskListPage(),
    },
  );
}

class MinimalExample extends StatelessWidget {
  const MinimalExample({super.key});

  List<PersistentTabConfig> _tabs() => [
    PersistentTabConfig(
      screen: const TaskListPage(),
      item: ItemConfig(
        activeForegroundColor: Colors.white,
        inactiveBackgroundColor: Colors.white,
        icon: const Icon(Icons.list),
        title: "Tarefas",
      ),
    ),
    PersistentTabConfig(
      screen: const TaskListPage(),
      item: ItemConfig(
        icon: const Icon(Icons.message),
        title: "Messages",
      ),
    ),
    PersistentTabConfig(
      screen: const TaskListPage(),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        title: "Settings",
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
    backgroundColor: Colors.red,
    tabs: _tabs(),
    navBarBuilder: (navBarConfig) => Style1BottomNavBar(
      navBarConfig: navBarConfig,
      navBarDecoration: NavBarDecoration(color: DefaultColors.navbarBackground),
    ),
    navBarOverlap: NavBarOverlap.full(),
  );
}