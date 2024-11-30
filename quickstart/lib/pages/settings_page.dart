import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/pages/home_page.dart';
import 'package:quickstart/pages/login_page.dart';
import 'package:quickstart/pages/user_profile_page.dart';
import 'package:quickstart/widgets/default_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sqlite/sqlite_repository.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.dbHelper});

  static String tag = '/settings';

  DatabaseConfiguration dbHelper;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isLoginRequired = true;
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker
  File? _profileImage; // Arquivo de imagem selecionado
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _isLoggedIn();
    _loadUser();
    _loadUserPicture();
  }

  Future<void> _loadUserPicture() async {
    final prefs = await SharedPreferences.getInstance();
    final String? picturePath = prefs.getString('user_picture');
    if (picturePath != null && picturePath.isNotEmpty) {
      _profileImage = File(picturePath);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      widget.dbHelper.saveUserPicture(pickedFile.path);
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<bool> _isLoggedIn() async {
    var bool = await widget.dbHelper.isUserLoggedIn();
    isLoginRequired = !bool;
    return bool;
  }

  Future<void> _loadUser() async {
    _user = await widget.dbHelper.getLoggedInUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Configurações',
            style: TextStyle(color: DefaultColors.title),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: DefaultColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContaSection(context),
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
                            widget.dbHelper.logoutUser();
                            Navigator.pushReplacementNamed(
                                context, HomePage.tag);
                            const snackBar = SnackBar(
                              content: Text(
                                "Usuario deslogado.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: const Text(
                            'Sair',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
    bool loggedIn = await _isLoggedIn();

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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: DefaultColors.title,
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, BuildContext context,
      [Function()? onTap]) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            color: DefaultColors.title,
          )),
      leading: Icon(
        icon,
        color: DefaultColors.cardBackgroud,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: DefaultColors.cardBackgroud,
      ),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildContaSection(BuildContext context) {
    if (isLoginRequired) {
      return _buildListTile('Login', Icons.person, context,
          () => _navigateToAccountOrLogin(context));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DefaultColors.cardBackgroud,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: DefaultColors.cardBackgroud,
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
                color: DefaultColors.title,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),
            const SizedBox(height: 5),
            // Outras informações do usuário
            infoRow(Icons.email, 'E-mail:', _user!.email!),
            const SizedBox(height: 5),
            // Divider(thickness: 1, color: Colors.grey.shade300),
            infoRow(Icons.calendar_month_outlined, 'Data de Nascimento:',
                _user!.birthDate!),
            const SizedBox(height: 5),
            infoRow(Icons.phone, 'Telefone:', _user!.phone!),
            // Divider(thickness: 1, color: Colors.grey.shade300),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: infoRow(Icons.key, 'Senha:', '***************'),
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
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String title, String info) {
    return Row(
      children: [
        Icon(
          icon,
          color: DefaultColors.cardBackgroud,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DefaultColors.title,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          info,
          style: TextStyle(
            color: DefaultColors.cardBackgroud,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
