import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F9), // Fundo cor #F4F4F9
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Minha Conta',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Adiciona a imagem das esferas no topo direito
          Positioned(
            top: -50,  // Ajuste conforme necessário
            right: -50, // Ajuste conforme necessário
            child: Image.asset(
              'lib/assets/images/cir_perfil.png', // Caminho para a imagem
              width: 300, // Ajuste o tamanho conforme necessário
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagem do perfil
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                SizedBox(height: 10),
                // Nome do usuário
                Text(
                  'João Pedro',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                // E-mail
                buildInfoRow('E-mail:', 'joao@gmail.com'),
                SizedBox(height: 10),
                // Data de nascimento
                buildInfoRow('Data de Nascimento:', '18/09/1999'),
                SizedBox(height: 10),
                // Senha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildInfoRow('Senha:', '***********'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Alterar senha >',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Telefone
                buildInfoRow('Telefone:', '(11) 99999-1111'),
                SizedBox(height: 20),
                // Data de ingresso
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ingressou em: 22/09/2024',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Criar Tarefa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuração',
          ),
        ],
      ),
    );
  }

  // Função para construir as linhas de informações
  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
