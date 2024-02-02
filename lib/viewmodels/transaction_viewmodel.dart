import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_sample/models/transaction.dart';
import 'dart:convert';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/presentation/screens/home_screen.dart';

import '../models/response.dart';
import '../presentation/screens/transaction_result_screen.dart';

class TransactionService {
  Future<void> sendTransaction(
      BuildContext context,
      String merchantUserId,
      //String merchantAba,
      String consumerUserId,
      //String consumerAba,
      String amount,
      String description,
      //String nonce,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/quickResponse'),
        body: jsonEncode({
          "merchantUserId": merchantUserId,
          "consumerUserId": consumerUserId,
          "amount": amount,
          "description": description,
          "nonce": "1691550073018"
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final transactionJson = json.decode(response.body);
        final transaction = Response.fromJson(transactionJson);

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
          transactionCode: transaction.codigo,
          message: transaction.message,
          receipt: transaction.recibo,
        )));

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo establecer la conexión, intente más tarde.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error al conectarse con API servicio de quickResponse: $e');
    }
  }




  Future<void> loadTransactions(
      BuildContext context,
      String merchantUserId,
      //String merchantAba,
      String consumerUserId,
      //String consumerAba,
      String amount,
      String description,
      //String nonce,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/quickResponse'),
        body: jsonEncode({
          "merchantUserId": merchantUserId,
          "consumerUserId": consumerUserId,
          "amount": amount,
          "description": description,
          "nonce": "1691550073018"
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final transactionJson = json.decode(response.body);
        final transaction = Response.fromJson(transactionJson);

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
          transactionCode: transaction.codigo,
          message: transaction.message,
          receipt: transaction.recibo,
        )));

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo establecer la conexión, intente más tarde.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error al conectarse con API servicio de quickResponse: $e');
    }
  }


  static Future<List<QrTransaction>> getTransactions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/quickResponse?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final transactionJson = json.decode(response.body);
        final transactions = Transaction.fromJson(transactionJson);

        return transactions.data.qrTransactions ?? [];
      } else {
        throw Exception('Failed to get transaction list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con API servicio de Obtener Transacciones: $e');
      return [];
    }
  }



}

// class TransactionViewModel extends ChangeNotifier {
//   bool isLoading = false;
//
//   Future<void> sendTransaction(
//       BuildContext context,
//       String merchantUserId,
//       //String merchantAba,
//       String consumerUserId,
//       //String consumerAba,
//       String amount,
//       String description,
//       //String nonce,
//       ) async {
//     isLoading = true;
//     notifyListeners();
//
//
//     try {
//       final response = await http.post(
//         Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/quickResponse'),
//         body: jsonEncode({
//             "merchantUserId": merchantUserId,
//             "merchant_ABA": "string",
//             "consumerUserId": consumerUserId,
//             "consumer_ABA": "string",
//             "amount": amount,
//             "description": description,
//             "nonce": DateTime.now().toString()
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         final transactionJson = json.decode(response.body);
//         final transaction = Response.fromJson(transactionJson);
//
//         Navigator.push(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
//           transactionCode: transaction.codigo,
//           message: transaction.message,
//           receipt: transaction.recibo,
//         )));
//
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('No se pudo establecer la conexión, intente más tarde.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error al conectarse con API servicio de quickResponse: $e');
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
// }