import 'package:flutter/material.dart';
import 'package:runtask/pages/login_page.dart';
import 'package:runtask/pages/sing_up_page.dart';
import 'package:runtask/pages/perfil_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PerfilPage(), // Corrigido para 'PerfilPage()' com letra maiúscula
    );
  }
}
