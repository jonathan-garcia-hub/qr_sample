import 'package:http/http.dart' as http;
import 'package:qr_sample/models/commerce.dart';
import 'dart:convert';

class CommerceService {
  static Future<List<CommerceElement>> getCompanies(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://thannajo.ddns.net:8090/api-echo/v1/commerces/details?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final commerceJson = json.decode(response.body);
        final commerce = Commerce.fromJson(commerceJson);

        return commerce.data.commerces ?? [];
      } else {
        throw Exception('Failed to get companies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con API servicio de Obtener Comercio: $e');
      return [];
    }
  }
}