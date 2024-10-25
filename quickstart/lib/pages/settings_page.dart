import 'package:flutter/material.dart';
import 'package:quickstart/pages/home_page.dart';
import 'package:quickstart/pages/login_page.dart';
import 'package:quickstart/pages/user_profile_page.dart';
import 'package:quickstart/widgets/default_colors.dart';
import '../sqlite/sqlite_repository.dart'; // Importa seu repositório

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key, required this.dbHelper});

  static String tag = '/settings';

  DatabaseConfiguration dbHelper;

  // Função para verificar se o usuário está logado no banco de dados
  Future<bool> isLoggedIn() async {
    return await dbHelper.isUserLoggedIn(); // Método que verifica o status de login no banco
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: DefaultColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Conta'),
              // Adiciona navegação para "Minha Conta" ou "Login"
              _buildListTile('Minha conta', Icons.person, context, () => _navigateToAccountOrLogin(context)),
              const Divider(),
              _buildSectionTitle('Notificações'),
              _buildListTile('Lembretes', Icons.notifications, context),
              _buildListTile('Notificação de Conclusão para Hoje', Icons.today, context),
              const Divider(),
              _buildSectionTitle('Preferências'),
              _buildListTile('Tema', Icons.color_lens, context),
              const Divider(),
              _buildSectionTitle('Ajuda'),
              _buildListTile('Perguntas Frequentes', Icons.help, context),
              _buildListTile('Saiba mais', Icons.info_outline, context),
              _buildListTile('Feedback', Icons.feedback, context),
              const Divider(),
              _buildSectionTitle('Sobre'),
              _buildListTile('Versão', Icons.info, context),
              _buildListTile('Privacidade', Icons.privacy_tip, context),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            dbHelper.logoutUser();
                            Navigator.pushReplacementNamed(context, HomePage.tag);
                            const snackBar = SnackBar(
                              content: Text(
                                "Usuario deslogado.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: const Text(
                            'Sair',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implementar função de excluir conta
                          },
                          child: const Text(
                            'Excluir conta',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função responsável por navegar para "Minha Conta" ou "Login" baseado no status de login
  void _navigateToAccountOrLogin(BuildContext context) async {
    bool loggedIn = await isLoggedIn();

    if (loggedIn) {
      // Se o usuário estiver logado, navega para a tela de "Minha Conta"
      Navigator.pushNamed(context, ProfilePage.tag);
    } else {
      // Caso contrário, navega para a tela de login
      Navigator.pushNamed(context, LoginPage.tag);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Função para construir um ListTile com navegação opcional
  Widget _buildListTile(String title, IconData icon, BuildContext context, [Function()? onTap]) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap ?? () {}, // Usa a função passada ou uma função vazia como fallback
    );
  }
}
