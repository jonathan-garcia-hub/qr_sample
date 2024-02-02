import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/splash_screen.dart';
import 'package:qr_sample/viewmodels/login_viewmodel.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ],
        child: SplashScreen(),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:MaterialColor(
          0xFF221c46, // Cambia este valor al color hexadecimal que desees
          <int, Color>{
            50: Color(0xFF40c50d),
            100: Color(0xFF0f71e1),
            200: Color(0xFF092498),
            300: Color(0xFFFF5252), // Puedes agregar más tonos de color aquí
            400: Color(0xFFE91E63),
            500: Color(0xFFD81B60),
            600: Color(0xFFC2185B),
            700: Color(0xFFAD1457),
            800: Color(0xFF880E4F),
            900: Color(0xFFD81B60), // Puedes ajustar los valores de color según tus preferencias
          },
        ),
      ),
    );
  }
}
