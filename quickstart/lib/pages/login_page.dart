import 'package:flutter/material.dart';
import '../sqlite/sqlite_repository.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login_page';
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final DatabaseConfiguration _dbHelper = DatabaseConfiguration();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<void> _login() async {
      print('chegou na funçao');
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        print('chegou aqui');
        final teste = await _dbHelper.getCredentials(_emailController.text, _passwordController.text);
        print('o usuario vai logar ?: $teste');
      }
    }

    final logoImage = Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo na horizontal
      children: <Widget>[
        Image.asset(
          'lib/assets/images/logo.png', // Caminho da imagem no assets
          width: 100, // Largura da imagem
          height: 100, // Altura da imagem
        ),
        SizedBox(width: 8.0), // Espaçamento entre a imagem e o texto
        Text(
          'Quick\nStart', // Texto com quebra de linha
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36.0, // Tamanho do texto
            fontWeight: FontWeight.normal,
            fontFamily: 'Limelight-Regular',
            color: Color(0xFF9C9C9C)
          ),
        ),
      ],
    );

    final titlePage = Text('Entrar', style: TextStyle(fontSize: 32, color: Color(0xD9515151)),);

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      cursorColor: Colors.black,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          color: Colors.grey, // Cor da label quando não está focado
        ),
        fillColor: Colors.white, // Cor de fundo do input
        filled: true, // Habilita a cor de fundo do input
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder( // Borda quando o campo está focado
          borderSide: BorderSide(color: Colors.transparent), // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder( // Borda quando não está focado
          borderSide: BorderSide(color: Colors.transparent), // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder( // Borda padrão
          borderSide: BorderSide(color: Colors.transparent), // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final passwordField = TextFormField(
      obscureText: true,
      autofocus: false,
      cursorColor: Colors.black,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Senha",
        labelStyle: TextStyle(
          color: Colors.grey, // Cor da label quando não está focado
        ),
        fillColor: Colors.white, // Cor de fundo do input
        filled: true, // Habilita a cor de fundo do input
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder( // Borda quando o campo está focado
          borderSide: BorderSide(color: Colors.transparent), // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder( // Borda quando não está focado
          borderSide: BorderSide(color: Colors.transparent), // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder( // Borda padrão
          borderSide: BorderSide(color: Colors.transparent), // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final forgotPassword = Container(
      width: double.infinity,
      child: Text(
        'Esqueci a senha',
        textAlign: TextAlign.right, // Alinha o texto à direita
        style: TextStyle(
            fontSize: 18,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF4E7987),
            color: Color(0xFF4E7987)
        ),
      ),
    );


    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xCF86E1AB), // Cor de fundo
        foregroundColor: Colors.white,    // Cor do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Formato arredondado
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 9), // Espaçamento interno
      ),
      child: Text(
          'Login',
          style: TextStyle(color: Color(0x7D000000), fontSize: 20)
      ),
      onPressed: () {
        _login();
      },
    );

    final singUpButton = ElevatedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF7F7765), width: 3), // Cor e largura da borda
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 9), // Espaçamento interno
        backgroundColor: Color(0xCFF4DFB1),
      ),
      child: Text(
          'Registre-se',
          style: TextStyle(color: Color(0x6B060606), fontSize: 20),
      ),
      onPressed: () {
        Text('Entrou');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 2),
            logoImage,
            Spacer(flex: 1),
            titlePage,
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.66,
              decoration: BoxDecoration(
                color: Color(0xCFF4DFB1),
                border: Border.all(color: Color(0x61D8D1E4), width: 5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 24.0,left: 24.0, right: 24.0),
                children: <Widget>[
                  emailField,
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(height: 6.0),
                  forgotPassword,
                  SizedBox(height: 6.0),
                  loginButton,
                  SizedBox(height: 5.0),
                  singUpButton
                ],
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
