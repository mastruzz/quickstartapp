import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login_page';
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final titlePage = Text('Entrou');

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xCF86E1AB), // Cor de fundo
        foregroundColor: Colors.white,    // Cor do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Formato arredondado
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Espaçamento interno
      ),
      child: Text('Login'),
      onPressed: () {
        Text('Entrou');
      },
    );

    final singUpButton = ElevatedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF7F7765), width: 2), // Cor e largura da borda
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Espaçamento interno
        backgroundColor: Colors.transparent,
      ),
      child: Text(
          'Registre-se',
          style: TextStyle(color: Color(0xFF7F7765)),
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
            titlePage,
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
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
          ],
        ),
      ),
    );
  }
}
