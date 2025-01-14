
import 'package:flutter/material.dart';
import 'package:lista_facil/ui/core/ui/app_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if(mounted){
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AppHome()), 
      );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0377FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png', 
              width: 100, 
              height: 100,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}