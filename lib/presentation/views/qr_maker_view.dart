import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class QRMakerView extends StatefulWidget {
  final String userID;
  final String userName;
  final String userDoc;

  QRMakerView({
    required this.userID,
    required this.userName,
    required this.userDoc
  });

  @override
  _QRMakerViewState createState() => _QRMakerViewState();
}

//QR SCREEN
class _QRMakerViewState extends State<QRMakerView> {
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  // String _text = '';
  // final _mask = MaskTextInputFormatter(
  //   mask: "###.###,###",
  //   type: MaskAutoCompletionType.eager,
  // );

  String formatNumber(String input) {
    String cleanedText = input.replaceAll('.', '').replaceAll(',', '');
    int length = cleanedText.length;

    if (length <= 2) {
      return cleanedText;
    }

    String wholePart = cleanedText.substring(0, length - 2);
    String decimalPart = cleanedText.substring(length - 2);
    String formattedAmount = '$wholePart.$decimalPart';

    int formattedLength = formattedAmount.length;
    String finalText = '';

    for (int i = 0; i < formattedLength; i++) {
      if (i == 2) {
        finalText += ',';
      } else if ((i - 2) % 3 == 0 && i != 2) {
        finalText += '.';
      }
      finalText += formattedAmount[i];
    }

    return finalText;
  }

  void _generateQRCode() {
    String dataToEncode = "${widget.userID};${widget.userName};${widget.userDoc};${_textController1.text};${_textController2.text}";
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 250,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff221c46),
                version: 6,
                data: dataToEncode,
                embeddedImage: AssetImage('assets/Images/plxColor.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(60, 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [

          TextField(
            controller: _textController1,
            decoration: InputDecoration(
                labelText: 'Monto',
                counterText: ''
            ),
            keyboardType: TextInputType.number,
            maxLength: 10,
            // inputFormatters: [
            //   // Este formato bloquea el punto y la coma.
            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            // ],
            onChanged: (value) {
              String cleanedText = value.replaceAll('.', '').replaceAll(',', '');

              int length = cleanedText.length;
              String formattedAmount = '';
              int decimalIndex = 1;
              int separadorEntero = length - 2;

              for (int i = length - 1; i >= 0; i--) {
                print(i);
                if (i == decimalIndex && length > 2) {
                  formattedAmount += ',';
                  formattedAmount += cleanedText[i];
                } else if (separadorEntero % 4 == 0 && separadorEntero > 2){
                  formattedAmount += cleanedText[i];
                  formattedAmount += '.';
                }else{
                  formattedAmount += cleanedText[i];
                }
                separadorEntero --;

                print(formattedAmount);
              }

              _textController1.value = TextEditingValue(
                text: formattedAmount,
                selection: TextSelection.collapsed(offset: formattedAmount.length),
              );
            },
            textAlign: TextAlign.right,
          ),

          TextField(
            controller: _textController2,
            decoration: InputDecoration(labelText: 'Descripción'),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateQRCode,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Generar QR'),
          ),
        ],
      ),
    );
  }
}
