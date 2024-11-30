import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quickstart/pages/home_page.dart';
import 'package:quickstart/widgets/default_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String tag = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Timer(const Duration(seconds: 4), () {
      _controller.forward().then((_) {
        Navigator.pushReplacementNamed(context, HomePage.tag);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DefaultColors.background,
        body: Stack(
          children: [
            Positioned(
              top: -5,
              left: -42,
              child: Image.asset(
                'assets/images/cir_verd1.png',
                width: 200,
                height: 200,
              ),
            ),
            Positioned(
              top: 50,
              left: -65,
              child: Image.asset(
                'assets/images/cir_cinza1.png',
                width: 200,
                height: 200,
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/cir_2.png',
                width: 200,
                height: 200,
              ),
            ),

            Positioned(
              bottom: -90,
              right: -20,
              child: Image.asset(
                'assets/images/cir_4.png',
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
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 20),
                  const Column(
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
      ),
    );
  }
}