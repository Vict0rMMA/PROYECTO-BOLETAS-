import 'dart:convert';
import 'package:http/http.dart' as http;
import '../boleta.dart';

class BoletaService {
  final String baseUrl;

  BoletaService(this.baseUrl);

  Future<List<Boleta>> getBoletas() async {
    final response = await http.get(
      Uri.parse(baseUrl)
    );

    if (response.statusCode == 404) {
      throw Exception("No se encontraron boletas");
    }

    if (response.statusCode != 200) {
      throw Exception("No se pudieron cargar las boletas");
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((item) => Boleta.fromJson(item))
    .toList();
  }
}
