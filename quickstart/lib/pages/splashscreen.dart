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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: DefaultColors.background,
        body: Stack(
          children: [
            Positioned(
              top: screenHeight * -0.02,
              left: screenWidth * -0.1,
              child: Image.asset(
                'assets/images/cir_verd1.png',
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * -0.15,
              child: Image.asset(
                'assets/images/cir_cinza1.png',
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/cir_2.png',
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
              bottom: screenHeight * -0.1,
              right: screenWidth * -0.05,
              child: Image.asset(
                'assets/images/cir_4.png',
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                  ),
                  SizedBox(width: screenWidth * 0.05),
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
