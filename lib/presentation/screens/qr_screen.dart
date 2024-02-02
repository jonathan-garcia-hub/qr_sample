import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/result_screen.dart';

import '../../models/qr.dart';
import '../../viewmodels/login_viewmodel.dart';


class QRPage extends StatefulWidget {

  final QrResponse data;

  QRPage({required this.data});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {

  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    // _startTimer();
  }



  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Uint8List imageBytes = base64Decode(widget.data.responseData.qrCode.image);

    return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
    child: Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Images/pluxelogo.jpg', width: 150, height: 100),
                SizedBox(width: 50,),
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
                            backgroundColor: Color(0xff00eb5e),
                            radius: 16,
                            child: Text(
                              '2', // Iniciales del usuario
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xff221c46)),
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
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Text(
                              '3', // Iniciales del usuario
                              style: TextStyle(fontSize: 14, color: Color(0xff221c46)),
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
                    Text('Escanee el QR',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MyImageWidget(base64String: widget.data.responseData.qrCode.image),
                      // Image(
                      //   image: MemoryImage(imageBytes),
                      // ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        StatusUpdate(initialSeconds: 60, viewModel: LoginViewModel(), idpay: widget.data.responseData.payIntentId, data: widget.data,),


                        TimeCounter(initialSeconds: 60, viewModel: LoginViewModel(), idpay: widget.data.responseData.payIntentId, data: widget.data,), // Agregar el contador de tiempo aquí
                      ],
                    ),


                    SizedBox(height: 16),

                    Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return _isLoading
                            ? SpinKitCircle(
                          color: Color(0xff221c46),
                          size: 35.0,
                        )
                            : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              String test = await viewModel.cancelPay(widget.data.responseData.payIntentId);
                              print(test);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget.data, status: 'C',)));
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


}

class TimeCounter extends StatefulWidget {
  final int initialSeconds;
  final LoginViewModel viewModel; // Asegúrate de cambiar MyViewModel al tipo real de tu ViewModel
  final String idpay;
  final QrResponse data;

  TimeCounter({required this.initialSeconds, required this.viewModel, required this.idpay,required this.data});

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
        String test = await widget.viewModel.cancelPay(widget.idpay);
        print(test);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget.data, status: 'C',)));
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
  final LoginViewModel viewModel; // Asegúrate de cambiar MyViewModel al tipo real de tu ViewModel
  final String idpay;
  final QrResponse data;

  StatusUpdate({required this.initialSeconds, required this.viewModel, required this.idpay, required this.data});

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
    _timer2 = Timer.periodic(Duration(seconds: 10), (timer) async {
      String test = await widget.viewModel.getStatus(widget.idpay);
      print(test);
      if (test == "Cancelada"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget.data, status: 'C',)));
      }
      if (test == "Declinada"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget.data, status: 'D',)));
      }
      if (test == "Aprobada"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(data: widget.data, status: 'A',)));
      }
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