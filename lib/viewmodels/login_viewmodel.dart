import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/models/qr.dart';
import 'package:qr_sample/presentation/screens/home_screen.dart';
import 'package:qr_sample/presentation/screens/qr_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/afilliation.dart';
import '../models/apiKey_status_ok.dart';
import '../models/apikey_status_error.dart';
import '../models/listTransaction.dart';
import '../models/new_user.dart';
import '../models/qrStatus.dart';
import '../models/qr_response.dart';
import '../models/qr_status_response.dart';
import '../models/status.dart';
import '../models/token_refresh.dart';
import '../models/userDetail.dart';
import '../presentation/screens/qr_new_screen.dart';
import '../presentation/screens/transaction_result_screen.dart';
import '../util/apiKey_use_util.dart';
import '../util/biometric_util.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String bearer_token = 'DB4C730DCB274533A8A5644A44F234B9';
  String base_url = 'https://vale-qa.logicwareservices.com/merchant_v3/';
  String _base_url_new = 'https://sepagos.ddns.net:8091';
  String userKey = 'DC237F980C61466F';
  String userSecret = '462445D1BB2B42EA92D89E1A3E551332';
  String merchantId = '1-4915';

  final _auth = BiometricAuthUtil();
  final _apiKeyUtil = ApiKeyUtil();


  //OLD
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

        // Navigator.push(context, MaterialPageRoute(builder: (context) => QRNewPage(data: qr_response)));

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

  //OLD
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

  //OLD
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

  //OLD
  Future<void> login(BuildContext context, String username, String password) async {
    isLoading = true;
    notifyListeners();

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

        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(usuario: user)), (route) => false);

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
///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////







  //Login NUEVO
  Future<void> loginNew(BuildContext context, String username, String password) async {
    isLoading = true;
    notifyListeners();

    print(username+password);


    try {
      // HttpClient httpClient = HttpClient()
      //   ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // final response = await http.post(
      //
      //   Uri.parse('https://sepagos.ddns.net:8091/login'),
      //   body: jsonEncode({
      //     'email': username,
      //     'password': password,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      //PARA CONECTARSE A HTTPS CON CERTIFICADO AUTOFIRMADO NO RECOMENDADO PARA PRODUCCION
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.post(
          Uri.parse('https://sepagos.ddns.net:8091/login'),
          body: jsonEncode({
            'email': username,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        final user = NewUser.fromJson(userJson);

        _apiKeyUtil.storeApiKey(user.token);

        //Guardo credenciales cifradas en almacenamiento del tlf para habilitar biometria
        if (await _auth.hasEnabledBiometricAuth()){
          //Ya tiene credenciales guardadas las actualizo ?
          print('NO guardadas');

        }else{
          //No tiene entonces las guardo
          _auth.enableBiometricAuth(username, password);
          print('guardadas');
        }

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


  //Detalles del usuario
  Future<UserDetail> getUserDetail(BuildContext context, String username) async {
    isLoading = true;
    notifyListeners();

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      // HttpClient httpClient = HttpClient()
      //   ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // final response = await http.post(
      //
      //   Uri.parse('https://sepagos.ddns.net:8091/login'),
      //   body: jsonEncode({
      //     'email': username,
      //     'password': password,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      //PARA CONECTARSE A HTTPS CON CERTIFICADO AUTOFIRMADO NO RECOMENDADO PARA PRODUCCION
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
        Uri.parse('https://sepagos.ddns.net:8091/users/$username'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        final user = UserDetail.fromJson(userJson);

        return user;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo obtener el detalle de usuario, intente nuevamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return UserDetail.empty();
      }
    } catch (e) {
      print('Error al conectarse con API servicio de detalle de usuario: $e');
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
      return UserDetail.empty();
    }

  }


  //Afiliaciones, balance, etc
  Future<List<Afiliation>>  getAfiliation(
      BuildContext context,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
        Uri.parse(
            'https://sepagos.ddns.net:8091/wallet/affiliations'),
        // '$_baseUrl/api-echo/v1/transactions/123456789AAAAAC/12341113?batches=true&lotNumber=15'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + apiKey!
        },
      );

      if (response.statusCode == 200) {
        final afiliationsJson = json.decode(response.body);

        List<Afiliation> afiliations = [];
        for (var afiliationJson in afiliationsJson) {
          afiliations.add(Afiliation.fromJson(afiliationJson));
        }

        return afiliations;
      } else {

        final errorJson = json.decode(response.body);
        //final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text("Intentando obtener las afiliaciones"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return [];
      }
    } catch (e) {
      print('Error al conectarse con API servicio de afiliations: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return [];
  }


  //Listado de transacciones
  Future<List<ListTransaction>>  getListTransactions(
      BuildContext context,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
        Uri.parse(
            'https://sepagos.ddns.net:8091/wallet'),
        // '$_baseUrl/api-echo/v1/transactions/123456789AAAAAC/12341113?batches=true&lotNumber=15'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + apiKey!
        },
      );

      if (response.statusCode == 200) {
        final transactionsJson = json.decode(response.body);

        List<ListTransaction> transactions = [];
        for (var transactionJson in transactionsJson) {
          transactions.add(ListTransaction.fromJson(transactionJson));
        }

        return transactions;
      } else {

        final errorJson = json.decode(response.body);
        //final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text("Intentando obtener listado de transacciones"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return [];
      }
    } catch (e) {
      print('Error al conectarse con API servicio de afiliations: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return [];

  }

  //Crear QR nuevo
  Future<void> createNewQR(
      BuildContext context,
      String amount,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.post(
        Uri.parse('https://sepagos.ddns.net:8091/wallet'),
        body: jsonEncode({
          'amount': double.parse(amount),
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
      );

      if (response.statusCode == 200) {
        //bearer_token = response.headers['Authorization']!;
        final newQrJson = json.decode(response.body);
        final newQrJsonResponse = NewQrResponse.fromJson(newQrJson);

        print(newQrJsonResponse.qrCode.image);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(data: qr_response)));



        Navigator.push(context, MaterialPageRoute(builder: (context) => QRNewPage(QrData: newQrJsonResponse)));

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

  //Consultar status QR
  Future<String> getQRStatusNew(
      BuildContext context,
      String code,
      ) async {

    final apiKey = await _apiKeyUtil.getApiKey();

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
        Uri.parse('https://sepagos.ddns.net:8091/wallet?code=$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey!}'
        },
      );

      print(code);

      if (response.statusCode == 200) {
        final qrStatusJson = json.decode(response.body);

        final qrStatus = QrStatusResponse.fromJson(qrStatusJson);



        switch (qrStatus.status) {
          case "R":
            return "Leído";
          case "P":
            return "Pendiente";
          case "A":
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
              transactionCode: '00',
              message: "Transacción recibida correctamente",
              receipt: qrStatus.receipt,
            )));
            return "Aprobado";
          case "C":
            // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
            //   transactionCode: '01',
            //   message: "Transacción cancelada",
            //   receipt: qrStatus.receipt,
            // )));
            Navigator.pop(context);
            return "Cancelado";
          default:
            return "Pendiente";
        }

      }else if(response.statusCode == 412) {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Alerta'),
        //     content: Text('El QR ya no está disponible para procesar.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      } else {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Alerta'),
        //     content: Text('No se pudo establecer la conexión, intente más tarde A.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      }
    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('Error'),
      //     content: Text('No se pudo establecer la conexión, intente más tarde.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: Text('OK'),
      //       ),
      //     ],
      //   ),
      // );

    }
    return "Pendiente";
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

        // print('la acción de cancelar qr tuvo status: ${qrStatus.message}');

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new TransactionResultScreen(
          transactionCode: '01',
          message: 'Transacción cancelada',
          receipt: qrStatus.receipt,
        )));


      }else if(response.statusCode == 412) {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Error'),
        //     content: Text('El QR ya no está disponible para procesar.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      } else {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Alerta'),
        //     content: Text('No se pudo establecer la conexión, intente más tarde.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      }
    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('Error'),
      //     content: Text('No se pudo establecer la conexión, intente más tarde.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
      print('Error al conectarse con API servicio de quickResponse: $e');
    }
  }

}

