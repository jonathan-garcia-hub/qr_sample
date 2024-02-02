import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
final String commerceName;
final String commerceId;
final double transactionAmount;
final String reason;

ConfirmationScreen({
required this.commerceName,
required this.commerceId,
required this.transactionAmount,
required this.reason,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Confirmar Transacción'),
backgroundColor: Colors.teal,
),
body: Container(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Text(
'Comercio: $commerceName',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 18.0,
),
),
Text(
'ID del Comercio: $commerceId',
style: TextStyle(fontSize: 16.0),
),
SizedBox(height: 12.0),
Text(
'Monto de la Transacción: \$${transactionAmount.toStringAsFixed(2)}',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 18.0,
),
),
Text(
'Motivo: $reason',
style: TextStyle(fontSize: 16.0),
),
SizedBox(height: 24.0),
ElevatedButton(
onPressed: () {
_showConfirmationBottomSheet(context);
},
style: ElevatedButton.styleFrom(
primary: Colors.teal,
onPrimary: Colors.white,
padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
),
child: Text('Confirmar'),
),
],
),
),
);
}

_showConfirmationBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmar Transacción',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 24.0),
            Text('Nombre del Comercio:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(commerceName, style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 12.0),
            Text('ID del Comercio:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(commerceId, style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 12.0),
            Text('Monto de la Transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('\$${transactionAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 12.0),
            Text('Motivo:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(reason, style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar', style: TextStyle(fontSize: 18.0)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para confirmar la transacción
                    Navigator.of(context).pop();
                    _showSnackBar(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Confirmar', style: TextStyle(fontSize: 18.0)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _showSnackBar(BuildContext context) {
final snackBar = SnackBar(
content: Text('¡Transacción confirmada!'),
duration: Duration(seconds: 3),
backgroundColor: Colors.teal,
behavior: SnackBarBehavior.floating,
);

ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}
