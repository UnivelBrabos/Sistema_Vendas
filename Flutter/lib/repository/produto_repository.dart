import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProdutoRepository {
  final String baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/products/get_all'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar produtos: ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List;
    return list
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/get/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar produto $id: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

}
