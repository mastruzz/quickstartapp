import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker
  File? _profileImage; // Arquivo de imagem selecionado

  UserModel? _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await dbHelper.getLoggedInUser();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Salva a imagem selecionada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_user != null) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),
                  // Área para imagem de perfil
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage, // Abre a galeria para selecionar a imagem
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.greenAccent,
                            child: Icon(Icons.add, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Nome do usuário
                  Text(
                    _user!.fullName!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Outras informações do usuário
                  infoRow('E-mail:', _user!.email!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  infoRow('Data de Nascimento:', _user!.birthDate!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: infoRow('Senha:', '***************'),
                      ),
                      InkWell(
                        onTap: () {
                          // Navegar para alterar senha
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
                  infoRow('Telefone:', _user!.phone!),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  Text(
                    'Ingressou em: 22/09/2024',
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
