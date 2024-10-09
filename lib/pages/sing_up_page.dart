import 'package:flutter/material.dart';

class SingUpPage extends StatefulWidget {
  static String tag = 'sing_up_page';
  _SingUpPageState createState() => new _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
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

    final titlePage = Text('Registrar-se', style: TextStyle(fontSize: 32, color: Color(0xD9515151)),);

    final nameField = TextFormField(
      autofocus: false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Nome",
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

    final surnameField = TextFormField(
      autofocus: false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Sobrenome",
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

    final birthDateField = TextFormField(
      autofocus: false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Data de Nascimento",
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

    final confirmPasswordField = TextFormField(
      obscureText: true,
      autofocus: false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Confirmar Senha",
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

    final phoneNumberField = TextFormField(
      autofocus: false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Telefone",
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


    final singUpButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xCF86E1AB), // Cor de fundo
        foregroundColor: Colors.white,    // Cor do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Formato arredondado
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 9), // Espaçamento interno
      ),
      child: Text(
          'Registrar-se',
          style: TextStyle(color: Color(0x7D000000), fontSize: 20)
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
            SizedBox(height: 40.0),
            titlePage,
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 550,
              decoration: BoxDecoration(
                color: Color(0xCFF4DFB1),
                border: Border.all(color: Color(0x61D8D1E4), width: 5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 24.0,left: 24.0, right: 24.0),
                children: <Widget>[
                  nameField,
                  SizedBox(height: 15.0),
                  surnameField,
                  SizedBox(height: 15.0),
                  birthDateField,
                  SizedBox(height: 15.0),
                  emailField,
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(height: 15.0),
                  confirmPasswordField,
                  SizedBox(height: 15.0),
                  phoneNumberField,
                  SizedBox(height: 15.0),
                  singUpButton,
                ],
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
