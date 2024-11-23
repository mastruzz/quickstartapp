import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationConfig {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationConfig() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Solicita permissão para alarmes exatos
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final exactAlarmPermissionGranted =
          await androidPlugin.requestExactAlarmsPermission();
      final notificationPermission = await androidPlugin.requestNotificationsPermission();
      // final fullScreePermission = await androidPlugin.requestFullScreenIntentPermission();
      print("Permissão para alarmes exatos concedida: $exactAlarmPermissionGranted");
      print("Permissão para Notificacoes concedida: $notificationPermission");
      // print("Permissão para Tela cheia concedida: $fullScreePermission");
    }

    // Criação do canal de notificações
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_channel_id', // ID do canal
      'Task Notifications', // Nome do canal
      description: 'Reminders for tasks', // Descrição do canal
      importance: Importance.high, // Define a importância como alta
      enableVibration: true, // Ativa vibração
    );

    // Registra o canal no Android
    await androidPlugin?.createNotificationChannel(channel);
    print("Canal de notificações criado com sucesso.");

    // Configuração de inicialização para Android
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração para iOS e macOS
    const DarwinInitializationSettings darwinInitSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Configuração geral de inicialização
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    // Inicializa o plugin
    final initialized = await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notificação recebida: ${response.payload}");
      },
    );

    print("Plugin de notificações inicializado: $initialized");
  }

  Future<void> scheduleNotifications(
      int taskId, String taskTitle, DateTime dueDate) async {
    // Configuração para Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Reminders for tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    // Configuração para iOS e macOS
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();

    // Configuração geral
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: darwinDetails);

    // Verificação de inicialização do fuso horário
    try {
      tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      print("Fuso horário atual: $now");
    } catch (e) {
      print("Erro ao inicializar o fuso horário: $e");
      return;
    }

    // Notificação 1 dia antes
    final DateTime oneDayBefore = dueDate.subtract(Duration(days: 1));
    if (oneDayBefore.isAfter(DateTime.now())) {
      final tz.TZDateTime scheduleTime =
          tz.TZDateTime.from(oneDayBefore, tz.local);
      if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print("Horário de 1 dia antes já passou.");
      } else {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          taskId,
          'Lembrete: $taskTitle',
          'Está chegando o prazo da tarefa.',
          scheduleTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        print("Notificação agendada para 1 dia antes: $scheduleTime");
      }
    }

    // Notificação no dia
    if (dueDate.isAfter(DateTime.now())) {
      final tz.TZDateTime scheduleTime = tz.TZDateTime.from(dueDate, tz.local);
      if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print("Horário do dia da tarefa já passou.");
      } else {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          taskId + 1,
          'Último Dia!',
          'Hoje é o último dia para concluir a tarefa $taskTitle',
          scheduleTime,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exact,
        );
        print("Notificação agendada para o dia da tarefa: $scheduleTime");
      }
    }

  //   // Exemplo de notificação para testes
  //   try {
  //     final location = tz.getLocation('America/Sao_Paulo');
  //     final tz.TZDateTime testTime =
  //         tz.TZDateTime.now(location).add(const Duration(seconds: 30));
  //     if (testTime.isBefore(tz.TZDateTime.now(tz.local))) {
  //       print("Teste de notificação já passou.");
  //     } else {
  //       await flutterLocalNotificationsPlugin.zonedSchedule(
  //         taskId + 2,
  //         '[TESTE] Último Dia!',
  //         'Hoje é o último dia para concluir a $taskTitle',
  //         testTime,
  //         notificationDetails,
  //         androidScheduleMode: AndroidScheduleMode.inexact,
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //       print("Notificação de teste agendada para: $testTime");
  //     }
  //   } catch (e) {
  //     print("Erro ao agendar notificação de teste: $e");
  //   }
  }
}
