import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xFFF4F4F9),
      body: Stack(
        children: [
          // Imagem da esfera verde esquerda
          Positioned(
            top: -5, 
            left: -42, 
            child: Image.asset(
              'lib/assets/images/cir_verd1.png', // Caminho da imagem da esfera verde
              width: 200, // Ajuste o tamanho conforme necessário
              height: 200,
            ),
          ),
          // Imagem da esfera cinza esquerda
          Positioned(
            top: 50, 
            left: -65, 
            child: Image.asset(
              'lib/assets/images/cir_cinza1.png', 
              width: 200, 
              height: 200,
            ),
          ),

           Positioned(
            top: 0,
            right: 0, 
            child: Image.asset(
              'lib/assets/images/cir_2.png', 
              width: 200, 
              height: 200,
            ),
          ),

          Positioned(
            bottom: -90, 
            right: -20, 
            child: Image.asset(
              'lib/assets/images/cir_4.png', 
              width: 370, 
              height: 380,
            ),
          ),
          
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
               
                Image.asset(
                  'lib/assets/images/logo.png', 
                  width: 100, 
                  height: 100,
                ),
                SizedBox(width: 20), 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Quick",
                      style: TextStyle(
                        fontFamily: 'Limelight', 
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C9C9C),
                      ),
                    ),
                    Text(
                      "Start",
                      style: TextStyle(
                        fontFamily: 'Limelight', 
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C9C9C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Home Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  //teste
}
