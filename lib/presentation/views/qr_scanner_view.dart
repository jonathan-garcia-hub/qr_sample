import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_sample/models/qr_transaction.dart';
import 'package:qr_sample/viewmodels/transaction_viewmodel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../themes/kinpos_theme.dart';
import '../screens/transaction_verification_screen.dart';

class QRScannerView extends StatefulWidget {
  @override
  _QRScannerViewState createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanning = false;
  bool loadCamera = false;
  bool isLoading = false;
  TransactionService transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return
      isLoading?
      Center(
          child: SpinKitCircle(
            color: ThemeConfig.secondaryColor,
            size: 60.0,
          )

      ):
      Column(
          children: [
            Expanded(
              flex: 5,
              child:
              Stack(
                children: [
                  scanning ?
                      QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ):
                      Center(
                          child: Icon(
                              Icons.qr_code_scanner,
                              size: 150,
                          ),
                        ),
                ],
              )

            ),
            Expanded(
              flex: 1,
              child: Center(
                child: scanning
                    ? loadCamera ?
                    const SpinKitCircle(
                      color: ThemeConfig.secondaryColor,
                      size: 60.0,
                    )
                    :ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeConfig.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _stopScanning,
                        icon: const Icon(Icons.camera_alt, color: Colors.black,),
                        label: const Text('Desactivar', style: TextStyle(color: Colors.black)),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeConfig.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _startScanning,
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
                        label: const Text('Activar', style: TextStyle(color: Colors.black)),
                    ),
              ),
            ),
          ],
        );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanning) {
        setState(() {
          scanning = false;
          controller.pauseCamera();
        });

        //aqui llamar a la pagina de confirmación

        //llamar metodo de estatus


        // _showConfirmationBottomSheet(context, scanData.code.toString());

        List<String> listOfStrings = scanData.code!.split('&');

        await transactionService.readQRStatus(
          context,
          listOfStrings[2],
        ).then((value) => value > 0 ? print('VALUE es mayor a 0') : _showConfirmationBottomSheet(context, scanData.code.toString()));

      }
    });
  }

  void _startScanning() {
    setState(() {
      scanning = true;
      loadCamera = true;
    });

    Timer(Duration(seconds: 1), () {
      // Este código se ejecutará después de 2 segundos.
      controller?.resumeCamera();
      setState(() {
        loadCamera = false;
      });
    });
  }

  void _stopScanning() {
    setState(() {
      scanning = true;
      loadCamera = true;
    });

    Timer(Duration(seconds: 1), () {
      // Este código se ejecutará después de 2 segundos.
      setState(() {
        scanning = false;
        controller?.pauseCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showConfirmationBottomSheet(BuildContext context, String data) {

    List<String> listOfStrings = data.split('&');
    print(data);

    // final Map<String, dynamic> data2 = jsonDecode(data);
    // final QRTerminalTransaction modelo = QRTerminalTransaction.fromJson(data2);

    // print(modelo.monto);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Confirmar Transacción',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),

                Text('Terminal ID:', style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.secondaryColor)),
                Text(listOfStrings[0], style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 12.0),
                Text('Destinatario:', style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.secondaryColor)),
                Text(listOfStrings[1], style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 12.0),
                Text('Código:', style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.secondaryColor)),
                Text(listOfStrings[2], style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 12.0),
                Text('Monto:', style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.secondaryColor)),
                Text(listOfStrings[3], style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 12.0),
                Text('Fecha:', style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.secondaryColor)),
                Text(listOfStrings[4], style: TextStyle(fontSize: 18.0)),

                // Text('Nombre del Cobrador:', style: TextStyle(fontWeight: FontWeight.bold)),
                // Text(listOfStrings[1], style: TextStyle(fontSize: 18.0)),
                // SizedBox(height: 12.0),
                // Text('Identificación del Cobrador:', style: TextStyle(fontWeight: FontWeight.bold)),
                // Text(listOfStrings[2], style: TextStyle(fontSize: 18.0)),
                // SizedBox(height: 12.0),
                // Text('Monto de la Transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
                // Text("${listOfStrings[3]} Bs", style: TextStyle(fontSize: 18.0)),
                // SizedBox(height: 12.0),
                // Text('Motivo:', style: TextStyle(fontWeight: FontWeight.bold)),
                // Text(listOfStrings[4], style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await transactionService.cancelQRStatus(
                          context,
                          listOfStrings[2],
                        );
                        Navigator.of(context).pop();
                        listOfStrings.clear();
                      },
                      child: Text('Cancelar', style: TextStyle(fontSize: 18.0, color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Lógica para confirmar la transacción



                        //Llamar a metodo que envie al servicio la data y reciba el resultado para enviar a la siguiente pantalla
                        isLoading = true;
                        print(listOfStrings);
                        await transactionService.payQRStatus(
                          context,
                          listOfStrings[2],
                        ).then((value) => isLoading = false);
                        listOfStrings.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeConfig.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Confirmar', style: TextStyle(fontSize: 18.0, color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationScreen(BuildContext context, String data) {

    final Map<String, dynamic> data2 = jsonDecode(data);
    final QRTerminalTransaction modelo = QRTerminalTransaction.fromJson(data2);

    print(modelo.monto);


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(amount: modelo.monto, merchantName: modelo.comercio,),
      ),
    );



  }


}





