import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Voltar para a home ou para a tela anterior
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Conta'),
            _buildListTile('Minha conta', Icons.person, context),
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
                          // TODO: Implementar função de sair
                        },
                        child: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar função de excluir conta
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
      )
      ,
    );
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

  Widget _buildListTile(String title, IconData icon, BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // TODO: Implementar navegação ou ação quando cada item for tocado e adicionar na assinatura do metodo a function
      },
    );
  }
}
