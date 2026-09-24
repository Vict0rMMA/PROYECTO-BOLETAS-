import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../boleta.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class BoletaService {
  final String baseUrl;

  BoletaService(this.baseUrl);

  Future<List<Boleta>> getBoletas() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => Boleta.fromJson(item)).toList();
      }

      if (response.statusCode == 404) {
        throw const ApiException("No se encontraron boletas");
      }

      if (response.statusCode == 500) {
        throw const ApiException("El servidor no esta disponible");
      }

      throw ApiException('Error HTTP ${response.statusCode}');
    } on TimeoutException {
      throw const ApiException('El servidor tardo demasiado en responder');
    }
  }
}
