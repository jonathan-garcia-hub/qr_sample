

import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/apiKey_status_ok.dart';
import '../models/apikey_status_error.dart';
import '../models/token_refresh.dart';

class ApiKeyUtil {

  Future<void> storeApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', apiKey);
  }

  // Future<String?> getApiKey1() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_key');
  // }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final storedApiKey = prefs.getString('api_key');

    if (storedApiKey != null) {
      final isValid = await validateApiKey(storedApiKey);
      if (isValid) {
        print('valida');
        return storedApiKey;
      }else{
        print('no valida');
        final newApiKey = await fetchNewApiKey(storedApiKey);
        return newApiKey;
      }
    }

    return storedApiKey;
  }

  //Login NUEVO
  Future<bool> validateApiKey(String storedApiKey) async {

    try {

      //PARA CONECTARSE A HTTPS CON CERTIFICADO AUTOFIRMADO NO RECOMENDADO PARA PRODUCCION
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.get(
        Uri.parse('https://sepagos.ddns.net:8091/auth/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storedApiKey}'
        },
      );

      if (response.statusCode == 200) {
        final apiKeyOkJson = json.decode(response.body);
        final apiKeyOk = ApiKeystatusOk.fromJson(apiKeyOkJson);

        print(apiKeyOk.message+apiKeyOk.port.toString());

        return true; //Significa que está valida la apiKey
      } else {

        final apiKeyErrorJson = json.decode(response.body);
        final apiKeyError = ApiKeystatusError.fromJson(apiKeyErrorJson);

        print(apiKeyError.message);

        return false;
      }
    } catch (e) {
      print('Error al conectarse con API servicio de status apiKey: $e');

      return false;
    }

  }

  Future<String> fetchNewApiKey(String storedApiKey) async {

    try {

      //PARA CONECTARSE A HTTPS CON CERTIFICADO AUTOFIRMADO NO RECOMENDADO PARA PRODUCCION
      final httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(httpClient);

      final response = await client.post(
        Uri.parse('https://sepagos.ddns.net:8091/refresh'),
        body: jsonEncode({
          'token': storedApiKey,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final tokenJson = json.decode(response.body);
        final tokenRef = TokenRefresh.fromJson(tokenJson);

        print(tokenRef.token);

        storeApiKey(tokenRef.token);

        return tokenRef.token;
      } else {

        // final apiKeyErrorJson = json.decode(response.body);
        // final apiKeyError = ApiKeystatusError.fromJson(apiKeyErrorJson);
        //
        // print(apiKeyError.message);

        print("error");

        return "";
      }
    } catch (e) {
      print('Error al conectarse con API servicio de refresh apiKey: $e');

      return "";
    }
  }


}