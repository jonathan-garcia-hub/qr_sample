import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/qr_screen.dart';

import '../../viewmodels/login_viewmodel.dart';


class ScannerPage extends StatefulWidget {

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;



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
                            backgroundColor: Color(0xff00eb5e),
                            radius: 16,
                            child: Text(
                              '1', // Iniciales del usuario
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff221c46)),
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
                              style: TextStyle(fontSize: 14, color: Color(0xff221c46)),
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
                    Text('Indique el monto',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20, letterSpacing: 2.0), // Adjust the font size as needed
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // Call the formatAmount function when the text changes
                        String formattedAmount = formatAmount(value);
                        print(formattedAmount); // You can print or use the formatted amount as needed
                        if (formattedAmount == '0,00'){
                          _amountController.clear();
                        }else if (_amountController.text != formattedAmount) {
                          _amountController.text = formattedAmount;
                          _amountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: formattedAmount.length),
                          );
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[^0-9]')), // Allow only digits, commas, and periods
                      ],
                      maxLength: 12,
                      decoration: InputDecoration(
                        // labelText: 'Monto',
                        counterText: '',
                        hintText: 'XXXXXXXX , XX',
                        hintStyle: TextStyle(fontSize: 20), // Adjust the font size as needed
                        labelStyle: TextStyle(fontSize: 20), // Adjust the font size as needed
                        contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust vertical padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return _isLoading
                            ? SpinKitCircle(
                          color: Color(0xff221c46),
                          size: 65.0,
                        )
                            : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            if (_amountController.text.isNotEmpty) {
                              try {
                                await viewModel.createQR(context, _amountController.text.replaceAll(",", "."));
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Ingrese un monto.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff221c46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Text(
                                  'Generar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.qr_code,
                                  color: Color(0xff00eb5e),
                                  size: 40,
                                )
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
        child: const Padding(
          padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nombre del comercio', style: TextStyle(fontSize: 14, color: Colors.white),),
              ],
            ))
      ),
    ),
    );



  }


  String formatAmount(String input) {
    final numberFormat = NumberFormat("#,##0.00", "es");
    input = input.replaceAll(RegExp(r'[^\d.]'), ''); // Remove non-digit characters
    int parseNumber = int.parse(input.isEmpty ? '0' : input);
    input = parseNumber.toString();

    try {

      if (input.length <= 2) {
        // If there are one or two digits, display as 0,0X or 0,XX
        return "0,${input.padLeft(2, '0')}";
      } else {

        String formattedValue = input.substring(0, input.length-2) + ',' + input.substring(input.length-2, input.length);
        
        return formattedValue;
      }

    } catch (e) {
      return "0,00"; // Handle the case where parsing fails
    }
  }

  


}

