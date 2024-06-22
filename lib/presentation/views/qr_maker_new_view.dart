import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/presentation/screens/qr_screen.dart';

import '../../themes/bizz_theme.dart';
import '../../viewmodels/login_viewmodel.dart';


class QrMakerNewView extends StatefulWidget {

  @override
  _QrMakerNewViewState createState() => _QrMakerNewViewState();
}

class _QrMakerNewViewState extends State<QrMakerNewView> {

  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
    child: Column(
        children: [

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Generar código QR',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, letterSpacing: 2.0),
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        counterText: '',
                        hintText: 'XXXXXXXX , XX',
                      ),
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
                    ),
                    SizedBox(height: 15),
                    TextField(
                      // keyboardType: TextInputType.number,
                      controller: _descriptionController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, letterSpacing: 2.0),
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        counterText: '',
                        // hintText: 'XXXXXXXX , XX',
                      ),


                      maxLength: 30,
                    ),

                    SizedBox(height: 30),

                    Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return _isLoading
                            ? SpinKitCircle(
                          color: ThemeConfig.secondaryColor,
                          size: 65.0,
                        )
                            : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            if (_amountController.text.isNotEmpty) {
                              try {
                                await viewModel.createNewQR(context, _amountController.text.replaceAll(",", "."));
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Alerta'),
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
                            primary: ThemeConfig.primaryColor,
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
                                      color: ThemeConfig.tertiaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.qr_code,
                                  color: ThemeConfig.secondaryColor,
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

