import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/scanner_screen.dart';

import '../../models/qr.dart';
import '../../viewmodels/login_viewmodel.dart';


class ResultPage extends StatefulWidget {

  final QrResponse data;
  final String status;

  ResultPage({required this.data,required this.status});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _startTimer();
  }



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
    child: Scaffold(
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false, // Esto oculta la flecha de retroceso
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Images/pluxelogo.jpg', width: 150, height: 100),

              ],
            ),
            elevation: 0, // Elimina la sombra del AppBar
          ),
          const Divider(
              color: Color(0xff00eb5e),
              height: 1,
              thickness: 1.5
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff221c46),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // primer paso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila con el círculo y el texto
                      Row(
                        children: [
                          // Círculo con iniciales del usuario
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Text(
                              '1', // Iniciales del usuario
                              style: TextStyle(fontSize: 14, color: Color(0xff221c46)),
                            ),
                          ),
                          SizedBox(width: 8), // Espaciador
                          // Texto "Bienvenido, Jonathan"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Indique',
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                'Monto',
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Separador vertical
                  Container(
                    height: 40,
                    width: 1,
                    color: Color(0xff00eb5e),
                  ),

                  //Segundo paso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila con el círculo y el texto
                      Row(
                        children: [
                          // Círculo con iniciales del usuario
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Text(
                              '2', // Iniciales del usuario
                              style: TextStyle(fontSize: 14,color: Color(0xff221c46)),
                            ),
                          ),
                          SizedBox(width: 8), // Espaciador
                          // Texto "Bienvenido, Jonathan"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Escanee',
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                'QR',
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Separador vertical
                  Container(
                    height: 40,
                    width: 1,
                    color: Color(0xff00eb5e),
                  ),

                  //Tercer paso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila con el círculo y el texto
                      Row(
                        children: [
                          // Círculo con iniciales del usuario
                          CircleAvatar(
                            backgroundColor: Color(0xff00eb5e),
                            radius: 16,
                            child: Text(
                              '3', // Iniciales del usuario
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xff221c46)),
                            ),
                          ),
                          SizedBox(width: 8), // Espaciador
                          // Texto "Bienvenido, Jonathan"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resultado',
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                'Transacción',
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Separador vertical

                ],
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Resultado de la transacción',
                      style: TextStyle(fontSize: 24),
                    ),

                    SizedBox(height: 16),

                    getIconBasedOnStatus(widget.status),

                    SizedBox(height: 30),


                    //Boton para volver al inicio
                    // Botón para volver al inicio
                    ElevatedButton(
                      onPressed: () {
                        // Navegar de nuevo a la pantalla de inicio (puedes cambiar el nombre de la pantalla según tu estructura)
                        //Navigator.popUntil(context, ModalRoute.withName('/')); // Reemplaza '/' con la ruta de tu pantalla de inicio
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ScannerPage()), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff221c46), // Cambia el color según tu diseño
                      ),
                      child: Text('Volver al Inicio', style: TextStyle(fontSize: 16)),
                    ),



                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff221c46), // Color de fondo
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.data.responseData.merchant.name, style: TextStyle(fontSize: 14, color: Colors.white),),
              ],
            ))

      ),
    ),
    );
  }

  Widget getIconBasedOnStatus(String status) {
    switch (status) {
      case 'A':
        return
          Column(
            children: [
              Icon(Icons.check_circle, size: 120, color: Colors.green),
              Text('APROBADO', style: TextStyle(fontSize: 16))

            ],
          );

      case 'C':
        return
        Column(
          children: [
            Icon(Icons.cancel, size: 120, color: Colors.red),
            Text('CANCELADA',
                style: TextStyle(fontSize: 16)
            )
          ],
        );
      case 'D':
        return
        Column(
          children: [
            Icon(Icons.error, size: 120, color: Colors.orange),
            Text('DECLINADA',
                style: TextStyle(fontSize: 16))
          ],
        );
      default:
      // Si el estado no es A, C ni D, puedes mostrar un icono predeterminado
        return Icon(Icons.error, size: 120, color: Colors.grey);
    }
  }

}
