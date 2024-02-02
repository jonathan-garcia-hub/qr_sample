import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/models/qr.dart';
import 'package:qr_sample/presentation/screens/home_screen.dart';
import 'package:qr_sample/presentation/screens/qr_screen.dart';

import '../models/status.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String bearer_token = 'DB4C730DCB274533A8A5644A44F234B9';
  String base_url = 'https://vale-qa.logicwareservices.com/merchant_v3/';
  String userKey = 'DC237F980C61466F';
  String userSecret = '462445D1BB2B42EA92D89E1A3E551332';
  String merchantId = '1-4915';


  //Login con correo y password
  Future<void> createQR(
      BuildContext context,
      String amount,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('${base_url}API/paymentIntent/'),
        headers: {
          'Authorization': 'Bearer $bearer_token',
          'Content-Type':'application/json',
          'Accept' : 'application/json',
          'userKey':'$userKey',
          'userSecret':'$userSecret',
          'merchantId':'$merchantId',
        },

        body:jsonEncode({
          'merchant': {
            'merchantId': '$merchantId',
            'siteId': 'S01',
            'terminalId': 'T01',
            'lotId': '2',
            // 'transactionId': 'A1234'
          },
          'amount': double.parse(amount),
          'QRCode': true,
        }),
      );

      if (response.statusCode == 200) {
        //bearer_token = response.headers['Authorization']!;
        final qrJson = json.decode(response.body);
        final qr_response = QrResponse.fromJson(qrJson);

        print(qr_response.responseData.qrCode.image);

        Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(data: qr_response)));

      } else {
        print(response.statusCode.toString());
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Credenciales inválidas, intente nuevamente.'),
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
      print('Error al conectarse con API create qr: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  Future<String> getStatus(
      String payIntentId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse('${base_url}API/paymentIntent/$payIntentId'),
        headers: {
          'Authorization': 'Bearer $bearer_token',
          'Content-Type':'application/json',
          'Accept' : 'application/json',
          'userKey':'$userKey',
          'userSecret':'$userSecret',
          'merchantId':'$merchantId',
        },
      );

      if (response.statusCode == 200) {
        //bearer_token = response.headers['Authorization']!;
        final responseJson = json.decode(response.body);
        final statusResponse = StatusResponse.fromJson(responseJson);

        print(statusResponse.responseData.status);

          switch (statusResponse.responseData.status) {
            case "P":
              return "Pendiente";
            case "R":
              return "Leída";
            case "CR":
              return "Solicitud de cancelación";
            case "C":
              return "Cancelada";
            case "AR":
              return "Solicitud de aprobación";
            case "A":
              return "Aprobada";
            case "D":
              return "Denegada";
            default:
              return "Estado desconocido";
          }

      } else {
        print(response.statusCode.toString());

        return "Estado desconocido";

      }
    } catch (e) {
      print('Error al conectarse con API consultar status: $e');

      return "Estado desconocido";

    }
  }


  Future<String> cancelPay(
      String payIntentId,
      ) async {
    try {
      final response = await http.put(
        Uri.parse('${base_url}API/paymentIntent/$payIntentId'),
        headers: {
          'Authorization': 'Bearer $bearer_token',
          'Content-Type':'application/json',
          'Accept' : 'application/json',
          'userKey':'$userKey',
          'userSecret':'$userSecret',
          'merchantId':'$merchantId',
        },
        body:jsonEncode({
          'action': 'cancel',
          'merchant': {
            'merchantId': '$merchantId',
            'siteId': 'S01',
            'terminalId': 'T01',
            // 'lotId': '2',
            // 'transactionId': 'A1234'
          },
        }),
      );

      if (response.statusCode == 200) {
        //bearer_token = response.headers['Authorization']!;
        final responseJson = json.decode(response.body);
        final statusResponse = StatusResponse.fromJson(responseJson);

        print(statusResponse.responseData.status);

        switch (statusResponse.responseData.status) {
          case "P":
            return "Pendiente";
          case "R":
            return "Leída";
          case "CR":
            return "Solicitud de cancelación";
          case "C":
            return "Cancelada";
          case "AR":
            return "Solicitud de aprobación";
          case "A":
            return "Aprobada";
          case "D":
            return "Denegada";
          default:
            return "Estado desconocido";
        }

      } else {
        print(response.statusCode.toString());

        return "Estado desconocido";

      }
    } catch (e) {
      print('Error al conectarse con API consultar status: $e');

      return "Estado desconocido";

    }
  }




  Future<void> login(BuildContext context, String username, String password) async {
    isLoading = true;
    notifyListeners();


    print(password);
    try {
      final response = await http.post(

        Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/users/login?quickResponse=true'),
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        final user = User.fromJson(userJson);
        // print(user.data.usuario.roles[0].nombre);
        //Se valida que sea ROLE_USER
        // if (user.data.user.roles[0].name == 'ROLE_USER'){
        //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(usuario: user)), (route) => false);
        // }else{
        //   showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //       title: Text('Error'),
        //       content: Text('No posee el rol adecuado para acceder.'),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.pop(context),
        //           child: Text('OK'),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(usuario: user)), (route) => false);

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Credenciales inválidas, intente nuevamente.'),
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
      print('Error al conectarse con API servicio de login: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    isLoading = false;
    notifyListeners();
  }
}