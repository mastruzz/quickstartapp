import 'package:flutter/material.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.dbHelper});

  final DatabaseConfiguration dbHelper;

  static String tag = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState(dbHelper);
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState(this.dbHelper);

  final DatabaseConfiguration dbHelper;

  UserModel? _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser(); // Chama o método para carregar o usuário ao iniciar a página
  }

  Future<void> _loadUser() async {
    _user = await dbHelper.getLoggedInUser();
    setState(() {
      _isLoading =
          false; // Atualiza o estado para indicar que o carregamento terminou
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_user != null) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5), // Light gray background
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),
                  // Profile image
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.greenAccent,
                          child: Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // User Name
                  Text(
                    _user!.fullName!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email row
                  infoRow('E-mail:', _user!.email!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  // Birthdate row
                  infoRow('Data de Nascimento:', _user!.birthDate!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  // Password row with change link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: infoRow('Senha:', '***************'),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigate to change password screen
                        },
                        child: const Text(
                          'Alterar senha >',
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  // Phone number row
                  infoRow('Telefone:', _user!.phone!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  SizedBox(height: 20),
                  // Join date text
                  Text(
                    'ingressou em: 22/09/2024',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: Text('Nenhum usuário logado'));
    }
  }

  // Widget for creating each row with title and info
  Widget infoRow(String title, String info) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          info,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
