import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VendedoresRepository {
  final String baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/sellers/get_all'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar vendedores: ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List;
    return list.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/sellers/get/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar vendedor $id: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> create(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sellers/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar vendedor: ${response.statusCode}');
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sellers/put/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar vendedor $id: ${response.statusCode}');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/sellers/delete/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar vendedor $id: ${response.statusCode}');
    }
  }
}
