import 'package:flutter/material.dart';
import 'package:quickstart/pages/home_page.dart';
import 'package:quickstart/pages/login_page.dart';
import 'package:quickstart/pages/settings_page.dart';
import 'package:quickstart/pages/sing_up_page.dart';
import 'package:quickstart/pages/splashscreen.dart';
import 'package:quickstart/pages/user_profile_page.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Função para inicializar o banco de dados
  void _initializeDatabase() async {
    await dbHelper.db;
    print("Banco de dados inicializado");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickStart',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/splash',
      routes: {
        SplashScreen.tag: (context) => const SplashScreen(),
        HomePage.tag: (context) => HomePage(
              dbHelper: dbHelper,
            ),
        LoginPage.tag: (context) => LoginPage(
              dbHelper: dbHelper,
            ),
        SingUpPage.tag: (context) => SingUpPage(
              dbHelper: dbHelper,
            ),
        SettingsPage.tag: (context) => SettingsPage(
              dbHelper: dbHelper,
            ),
        ProfilePage.tag: (context) => ProfilePage(
              dbHelper: dbHelper,
            ),
      },
    );
  }
}
