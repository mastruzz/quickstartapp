import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:quickstart/pages/home_page.dart';
import 'package:quickstart/pages/login_page.dart';
import 'package:quickstart/pages/settings_page.dart';
import 'package:quickstart/pages/sing_up_page.dart';
import 'package:quickstart/pages/splashscreen.dart';
import 'package:quickstart/pages/user_profile_page.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/default_colors.dart';
import 'package:timezone/timezone.dart'
    as tz; // Para usar as funções de fuso horário
import 'package:timezone/data/latest.dart'
    as tz; // Para carregar os dados de fuso horário

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
  await FlutterStatusbarcolor.setStatusBarColor(DefaultColors.background);
  print("Timezone inicializado");
  tz.initializeTimeZones();

  // Inicializar Notificações
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings darwinInitSettings =
      DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: darwinInitSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState;
    _initializeDatabase;
    _initializeNotifications;
    _initializeTimeZone;
  }

  void _initializeTimeZone() {
    WidgetsFlutterBinding
        .ensureInitialized(); // Garante que os bindings do Flutter estejam prontos
    print("Timezone inicializado");
    tz.initializeTimeZones(); // Inicializa os fusos horários
  }

  void _initializeNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Configuração para Android
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração para iOS e macOS (Darwin-based systems)
    const DarwinInitializationSettings darwinInitSettings =
        DarwinInitializationSettings();

    // Inicialização geral
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
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
      locale: Locale('pt', 'BR'), // Define o idioma padrão como português brasileiro
      supportedLocales: [
        Locale('en', 'US'), // Inglês
        Locale('pt', 'BR'), // Português do Brasil
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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