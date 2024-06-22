import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/result_screen.dart';

import '../../models/qr.dart';
import '../../models/qr_response.dart';
import '../../themes/bizz_theme.dart';
import '../../viewmodels/login_viewmodel.dart';


class QRNewPage extends StatefulWidget {

  final NewQrResponse QrData;

  QRNewPage({required this.QrData});

  @override
  _QRNewPageState createState() => _QRNewPageState();
}

class _QRNewPageState extends State<QRNewPage> {

  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
    // _startTimer();
  }



  @override
  Widget build(BuildContext context) {

    String nombre = widget.QrData.merchant.name;
    List<String> palabras = nombre.split(' ');
    String iniciales = '';

    if (palabras.length >= 2) {
      iniciales += palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
    } else if (palabras.length > 0) {
      iniciales += palabras[0].substring(0, 1);
    }

    // Uint8List imageBytes = base64Decode(widget.data.responseData.qrCode.image);

    return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
    child: Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: ThemeConfig.primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(width: 50,),
                Image.asset(ThemeConfig.fullLogo, width: 100, height: 80),
                SizedBox(width: 30,),
              ],
            ),
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.logout, color: Colors.black,),
            //     onPressed: () {
            //       // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
            //       Navigator.pop(context);
            //     },
            //   ),
            // ],
            elevation: 0, // Elimina la sombra del AppBar
          ),
          const Divider(
              color: ThemeConfig.secondaryColor,
              height: 1,
              thickness: 1.5
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeConfig.primaryColor,
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
                  // Lado izquierdo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila con el círculo y el texto
                      Row(
                        children: [
                          // Círculo con iniciales del usuario
                          CircleAvatar(
                            backgroundColor: ThemeConfig.secondaryColor,
                            radius: 16,
                            child: Text(
                              iniciales, // Iniciales del usuario
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 8), // Espaciador
                          // Texto "Bienvenido, Jonathan"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido,',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                palabras[0],
                                style: TextStyle(fontSize: 16, color: Colors.black),
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
                    color: ThemeConfig.secondaryColor,
                  ),
                  // Lado derecho
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Identificación:',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        widget.QrData.merchant.cardTaxId,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
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
                    Text('Escanee el QR',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MyImageWidget(base64String: widget.QrData.qrCode.image),
                      // Image(
                      //   image: MemoryImage(imageBytes),
                      // ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        StatusUpdate(initialSeconds: 60, viewModel: LoginViewModel(), code: widget.QrData.qrCode.code,),

                        TimeCounter(initialSeconds: 60, viewModel: LoginViewModel(), code: widget.QrData.qrCode.code,),

                      ],
                    ),


                    SizedBox(height: 16),

                    Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return _isLoading
                            ? SpinKitCircle(
                          color: ThemeConfig.secondaryColor,
                          size: 35.0,
                        )
                            : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await viewModel.cancelQRStatus(context, widget.QrData.qrCode.code);
                              // Navigator.pop(context);

                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget., status: 'C',)));
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
          color: ThemeConfig.primaryColor, // Color de fondo
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
                Text("${widget.QrData.merchant.name} - ${widget.QrData.merchant.city}", style: TextStyle(fontSize: 14, color: Colors.black),),
              ],
            ))

      ),
    ),
    );
  }

}

class TimeCounter extends StatefulWidget {
  final int initialSeconds;
  final LoginViewModel viewModel; // Asegúrate de cambiar MyViewModel al tipo real de tu ViewModel
  final String code;

  TimeCounter({required this.initialSeconds, required this.viewModel, required this.code});

  @override
  _TimeCounterState createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState((){
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          //Se declina el pago
          _timer.cancel();
        }
      });
      if (_secondsRemaining == 0){
        // Navigator.pop(context);
        await widget.viewModel.cancelQRStatus(context, widget.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: 16),
    );
  }
}


class StatusUpdate extends StatefulWidget {
  final int initialSeconds;
  final LoginViewModel viewModel;
  final String code;

  StatusUpdate({required this.initialSeconds, required this.viewModel, required this.code});

  @override
  _StatusUpdateState createState() => _StatusUpdateState();
}

class _StatusUpdateState extends State<StatusUpdate> {
  late Timer _timer2;
  int _secondsRemaining = 0;
  String _Status = 'Pendiente';


  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer2.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
    _timer2 = Timer.periodic(const Duration(seconds: 5), (timer) async {
      String test = await widget.viewModel.getQRStatusNew(context, widget.code);
      print(test);
      // "R" -> "LEIDO";
      // case "C" -> "CANCELADO";
      // case "A" -> "APROBADO";
      // case "P" -> "PENDIENTE";
      setState(() {
        _Status = test;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Estatus: ',
            style: TextStyle(fontSize: 16)
        ),
        Text('$_Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class MyImageWidget extends StatelessWidget {
  final String base64String;

  MyImageWidget({required this.base64String});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: _decodeImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se decodifica la imagen
          return SizedBox();
        } else if (snapshot.hasError) {
          // Muestra un widget de error si ocurre un error durante la decodificación
          return Text('Error al decodificar la imagen');
        } else if (snapshot.hasData) {
          // Muestra la imagen decodificada
          return snapshot.data!;
        } else {
          // Muestra un widget predeterminado si no hay datos ni errores
          return Placeholder();
        }
      },
    );
  }

  Future<Image> _decodeImage() async {
    // Decodificar la cadena base64 en bytes
    List<int> imageBytes = base64Decode(base64String);

    // Crear una imagen desde los bytes decodificados
    final image = Image.memory(Uint8List.fromList(imageBytes));

    // Retornar la imagen
    return image;
  }
}