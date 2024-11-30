import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/pages/login_page.dart';
import 'package:quickstart/widgets/default_colors.dart';
import '../sqlite/sqlite_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SingUpPage extends StatefulWidget {
  static String tag = '/singup';

  SingUpPage({super.key, required this.dbHelper});

  DatabaseConfiguration dbHelper;

  _SingUpPageState createState() => _SingUpPageState(dbHelper);
}

class _SingUpPageState extends State<SingUpPage> {
  _SingUpPageState(this.dbHelper);

  DatabaseConfiguration dbHelper;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController birthDateController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    String? validatePasswordMatch(String? value) {
      if (value != passwordController.text) {
        return 'As senhas não coincidem';
      }
      return null;
    }

    void clearFields() {
      nameController.clear();
      surnameController.clear();
      birthDateController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      phoneController.clear();
    }

    // Função auxiliar para exibir o Snackbar de erro
    void showErrorSnackbar(BuildContext context, String message) {
      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: DefaultColors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Validação de email
    bool isValidEmail(String email) {
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

// Validação de telefone
    bool isValidPhone(String phone) {
      // Verifica se o telefone tem o formato esperado de (##) #####-####
      String pattern = r'^\(\d{2}\) \d{5}-\d{4}$';
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(phone);
    }

    Future<void> addUser(BuildContext context) async {
      if (nameController.text.isEmpty) {
        showErrorSnackbar(context, "Por favor, insira o nome.");
        return;
      }
      if (surnameController.text.isEmpty) {
        showErrorSnackbar(context, "Por favor, insira o sobrenome.");
        return;
      }
      if (birthDateController.text.isEmpty) {
        showErrorSnackbar(context, "Por favor, insira a data de nascimento.");
        return;
      }
      if (emailController.text.isEmpty || !isValidEmail(emailController.text)) {
        showErrorSnackbar(context, "Por favor, insira um email válido.");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorSnackbar(context, "Por favor, insira a senha.");
        return;
      }
      if (phoneController.text.isEmpty || !isValidPhone(phoneController.text)) {
        showErrorSnackbar(
            context, "Por favor, insira um número de telefone válido.");
        return;
      }

      UserModel user = UserModel(
          fullName: "${nameController.text} ${surnameController.text}",
          email: emailController.text,
          birthDate: birthDateController.text,
          phone: phoneController.text,
          password: passwordController.text);

      await dbHelper.insertUser(user.toMap());
      final teste = await dbHelper.getAllUsers();
      print('esse é o teste: $teste');
      clearFields();
    }

    final logoImage = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 8.0), // Espaçamento entre a imagem e o texto
        Text(
          'Quick\nStart', // Texto com quebra de linha
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 36.0, // Tamanho do texto
              fontWeight: FontWeight.normal,
              fontFamily: 'Limelight-Regular',
              color: DefaultColors.title),
        ),
      ],
    );

    final titlePage = Text(
      'Registrar-se',
      style: TextStyle(fontSize: 32, color: DefaultColors.title),
    );

    final nameField = TextFormField(
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: nameController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      decoration: InputDecoration(
        hintText: "seu nome",
        hintStyle: TextStyle(color: Colors.grey),
        labelText: "Nome",
        labelStyle: TextStyle(
          color: DefaultColors.title, // Cor da label quando não está focado
        ),
        fillColor: DefaultColors.searchBarBackground,
        // Cor de fundo do input
        filled: true,
        // Habilita a cor de fundo do input
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          // Borda quando o campo está focado
          borderSide: const BorderSide(color: Colors.transparent),
          // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          // Borda quando não está focado
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          // Borda padrão
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final surnameField = TextFormField(
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: surnameController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      decoration: InputDecoration(
        hintText: "seu sobrenome",
        hintStyle: TextStyle(color: Colors.grey),
        labelText: "Sobrenome",
        labelStyle: TextStyle(
          color: DefaultColors.title, // Cor da label quando não está focado
        ),
        fillColor: DefaultColors.searchBarBackground,
        // Cor de fundo do input
        filled: true,
        // Habilita a cor de fundo do input
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          // Borda quando o campo está focado
          borderSide: BorderSide(color: Colors.transparent),
          // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          // Borda quando não está focado
          borderSide: BorderSide(color: Colors.transparent),
          // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          // Borda padrão
          borderSide: BorderSide(color: Colors.transparent),
          // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final birthDateField = TextFormField(
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: birthDateController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      keyboardType: TextInputType.datetime,
      // Tipo de teclado específico para datas
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Permitir apenas números
        DateFormatter(), // Formatação personalizada para dd/mm/yyyy
      ],
      decoration: InputDecoration(
        hintText: "dd/mm/yyyy",
        hintStyle: TextStyle(color: Colors.grey),
        labelText: "Data de Nascimento",
        labelStyle: TextStyle(color: DefaultColors.title),
        fillColor: DefaultColors.searchBarBackground,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        // Formatação automática (opcional) ao editar o campo
        if (value.length == 10) {
          try {
            final formattedDate = DateFormat('dd/MM/yyyy').parseStrict(value);
            // Validação adicional pode ser feita aqui
          } catch (e) {
            showErrorSnackbar(context, "Formato de data inválida.");
          }
        }
      },
    );

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: emailController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      decoration: InputDecoration(
        hintText: "email@email.com",
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: "Email",
        labelStyle: TextStyle(
          color: DefaultColors.title, // Cor da label quando não está focado
        ),
        fillColor: DefaultColors.searchBarBackground,
        // Cor de fundo do input
        filled: true,
        // Habilita a cor de fundo do input
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          // Borda quando o campo está focado
          borderSide: const BorderSide(color: Colors.transparent),
          // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          // Borda quando não está focado
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          // Borda padrão
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final passwordField = TextFormField(
      obscureText: true,
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: passwordController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      decoration: InputDecoration(
        hintText: "***********",
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: "Senha",
        labelStyle: TextStyle(
          color: DefaultColors.title, // Cor da label quando não está focado
        ),
        fillColor: DefaultColors.searchBarBackground,
        // Cor de fundo do input
        filled: true,
        // Habilita a cor de fundo do input
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          // Borda quando o campo está focado
          borderSide: BorderSide(color: Colors.transparent),
          // Removendo a cor da borda ao focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          // Borda quando não está focado
          borderSide: BorderSide(color: Colors.transparent),
          // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          // Borda padrão
          borderSide: BorderSide(color: Colors.transparent),
          // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final confirmPasswordField = TextFormField(
      obscureText: true,
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: confirmPasswordController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      validator: validatePasswordMatch,
      decoration: InputDecoration(
        hintText: "***********",
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: "Confirmar Senha",
        labelStyle: TextStyle(
          color: DefaultColors.title,
        ),
        fillColor: DefaultColors.searchBarBackground,
        // Cor de fundo do input
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final phoneNumberField = TextFormField(
      autofocus: false,
      cursorColor: DefaultColors.cardBackgroud,
      controller: phoneController,
      style: TextStyle(color: DefaultColors.title),  // Cor do texto digitado
      keyboardType: TextInputType.phone,
      inputFormatters: [
        MaskedInputFormatter('(##) #####-####'),
      ],
      decoration: InputDecoration(
        hintText: "(00)00000-0000",
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: "Telefone",
        labelStyle: TextStyle(
          color: DefaultColors.title,
        ),
        fillColor: DefaultColors.searchBarBackground,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          // Borda quando não está focado
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda ao não focar
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          // Borda padrão
          borderSide: const BorderSide(color: Colors.transparent),
          // Remove a borda padrão
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final singUpButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColors.doneCardBackgroud ,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 9),
        ),
        child: Text('Registrar-se',
            style: TextStyle(color: DefaultColors.title, fontSize: 20)),
        onPressed: () {
          try {
            addUser(context);
            Navigator.pushReplacementNamed(context, LoginPage.tag);
            const snackBar = SnackBar(
              content: Text(
                "Cadastro realizado com sucesso!.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } catch (exception) {
            showErrorSnackbar(
              context,
              "Erro durante o cadastro, tente novamente mais tarde.",
            );
          }
        });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, LoginPage.tag);
          },
        ),
      ),
      backgroundColor: DefaultColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logoImage,
              const SizedBox(height: 30.0),
              // titlePage,
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  color: DefaultColors.background,
                  border: Border.all(color: DefaultColors.cardBorder, width: 5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    const SizedBox(height: 15.0),
                    surnameField,
                    const SizedBox(height: 15.0),
                    birthDateField,
                    const SizedBox(height: 15.0),
                    emailField,
                    const SizedBox(height: 15.0),
                    passwordField,
                    const SizedBox(height: 15.0),
                    confirmPasswordField,
                    const SizedBox(height: 15.0),
                    phoneNumberField,
                    const SizedBox(height: 15.0),
                    singUpButton,
                  ],
                ),
              ),
              const SizedBox(height: 30.0), // Espaçamento final
            ],
          ),
        ),
      ),
    );
  }
}

// Classe personalizada para formatar o input
class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Remove tudo que não seja número
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Aplica a formatação conforme o tamanho do texto
    if (text.length >= 3 && text.length <= 4) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    } else if (text.length >= 5) {
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4, 8);
    }

    // Retorna o valor formatado e move o cursor para o final do texto
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
