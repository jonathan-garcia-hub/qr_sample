import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_sample/models/transaction.dart';
import 'dart:convert';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/qrStatus.dart';
import '../models/response.dart';
import '../presentation/screens/transaction_result_screen.dart';
import 'package:http/io_client.dart';

import '../util/apiKey_use_util.dart';


class TransactionService {

  final _apiKeyUtil = ApiKeyUtil();


  Future<int> readQRStatus(
      BuildContext context,
      String code,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.put(
        Uri.parse('https://sepagos.ddns.net:8091/wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
        body: jsonEncode({
          "action": 'READ',
          "code": code
        }),
      );

      if (response.statusCode == 200) {
        final qrStatusJson = json.decode(response.body);
        final qrStatus = QrStatus.fromJson(qrStatusJson);

        print('la acción de leer qr tuvo status: ${qrStatus.message}');

        return 0;

        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
        //   transactionCode: transaction.codigo,
        //   message: transaction.message,
        //   receipt: transaction.recibo,
        // )));

      }else if(response.statusCode == 412) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('El QR ya no está disponible para procesar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

        return 1;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Alerta'),
            content: Text('No se pudo establecer la conexión, intente más tarde.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

        return 1;
      }
    } catch (e) {
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

      print('Error al conectarse con API servicio de quickResponse: $e');
    }
    return 1;
  }


  Future<void> payQRStatus(
      BuildContext context,
      String code,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.put(
        Uri.parse('https://sepagos.ddns.net:8091/wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
        body: jsonEncode({
          "action": 'PAY',
          "code": code
        }),
      );

      if (response.statusCode == 200) {
        final qrStatusJson = json.decode(response.body);
        final qrStatus = QrStatus.fromJson(qrStatusJson);

        print('la acción de pagar qr tuvo status: ${qrStatus.message}');

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
          transactionCode: '00',
          message: "Pago realizado correctamente",
          receipt: qrStatus.receipt,
        )));

      }else if(response.statusCode == 412) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('El QR ya no está disponible para procesar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Alerta'),
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
      print('Error al conectarse con API servicio de quickResponse: $e');
    }
  }


  Future<void> cancelQRStatus(
      BuildContext context,
      String code,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.put(
        Uri.parse('https://sepagos.ddns.net:8091/wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
        body: jsonEncode({
          "action": 'CANCEL',
          "code": code
        }),
      );

      if (response.statusCode == 200) {
        final qrStatusJson = json.decode(response.body);
        final qrStatus = QrStatus.fromJson(qrStatusJson);

        print('la acción de cancelar qr tuvo status: ${qrStatus.message}');

      }else if(response.statusCode == 412) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('El QR ya no está disponible para procesar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Alerta'),
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
      print('Error al conectarse con API servicio de quickResponse: $e');
    }
  }




















  //OLD
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
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.post(
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
          message: 'TEST',
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

  //OLD
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



      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.post(
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
          message: 'TEST',
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

  //OLD
  static Future<List<QrTransaction>> getTransactions(String userId) async {
    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
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
