import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:qr_sample/viewmodels/login_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:qr_sample/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // void _login() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // Simulate API call
  //   try{
  //     final response = await http.post(
  //       Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/users/login'),
  //       body: jsonEncode({
  //         'email': _usernameController.text,
  //         'userpass': _passwordController.text,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // API call successful, navigate to home screen
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //     } else {
  //       // API call failed, show error message
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Error'),
  //           content: Text('Credenciales inválidas, intente nuevamente.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }catch(e){
  //     print('Error al conectarse con API servicio de login: $e');
  //   }
  //
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Forma en la esquina superior izquierda
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 50,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff221c46), Color(0xff00eb5e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: 0,
              child: Container(
                width: 80,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff221c46), Color(0xff00eb5e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            // Forma en la esquina inferior derecha
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 100,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff221c46), Color(0xff00eb5e)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Center(
              child: Consumer<LoginViewModel>(
                builder: (context, viewModel, child) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Image.asset('assets/Images/plxLogo.png', width: 120),
                              // SizedBox(height: 10),
                              //Image.asset('assets/Images/ilustration3.svg', width: 300),
                              SvgPicture.asset(
                                'assets/Images/ilustration3.svg',
                                width: 250,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Inicio de Sesión',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(labelText: 'Correo'),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Contraseña'),
                          ),
                        ),
                        SizedBox(height: 40),
                        _isLoading
                            ? SpinKitCircle(
                                color: Color(0xff221c46),
                                size: 40.0,
                              )
                            : Container(
                          width: 200, // Ajusta el ancho según tus necesidades
                          child: ElevatedButton(
                            onPressed: () {
                              _isLoading = true;
                              final viewModel = Provider.of<LoginViewModel>(context, listen: false);
                              viewModel.login(context, _usernameController.text, _passwordController.text).then((value) => _isLoading = false);
                              //_isLoading = false;
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // Gradiente en el botón 'ACCEDER'
                              primary: Colors.blue, // Cambia este color según tus preferencias
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xff221c46),Color(0xff221c46), ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'ACCEDER',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

