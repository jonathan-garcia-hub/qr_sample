import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class TransactionResultScreen extends StatefulWidget {
  final String transactionCode;
  final String message;
  final String receipt;

  TransactionResultScreen({
    required this.transactionCode,
    required this.message,
    required this.receipt,
  });

  @override
  _TransactionResultScreenState createState() =>
      _TransactionResultScreenState();
}

class _TransactionResultScreenState extends State<TransactionResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado de Transacción'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.transactionCode == '00' ?
              Text(
                'Transacción realizada exitosamente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ):
              Text(
                'Error en transacción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            widget.transactionCode == '00' ?
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ):
              Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 100,
              ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Text(widget.receipt),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed:() async {
                    // Guarda el texto como un archivo PDF
                    // final bytes = widget.receipt.codeUnits.map((int codeUnit) => codeUnit.toRadixString(16)).toList();
                    // final file = File('${getTemporaryDirectory()}/text.pdf')..writeAsStringSync(bytes.join());
                    // Share.shareFiles([file.path]);
                    Share.share(widget.receipt);
                  },
                  icon: Icon(Icons.share),
                  label: Text('Compartir'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

