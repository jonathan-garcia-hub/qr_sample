import 'package:flutter/material.dart';
import 'package:qr_sample/presentation/screens/scanner_screen.dart';

import 'login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate some initialization work
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ScannerPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 1000),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xff221c46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Images/plxColor.png'),
            SizedBox(height: 50), // Espaciado entre la imagen y el spinner
            SpinKitCircle(
              color: Colors.white,
              size: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}