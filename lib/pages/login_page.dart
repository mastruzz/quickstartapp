import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login_page';
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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

    final titlePage = Text('Entrou', style: TextStyle(fontSize: 32, color: Color(0xD9515151)),);

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      cursorColor: Colors.black,
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
        Text('Entrou');
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
                  SizedBox(height: 28.0),
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
