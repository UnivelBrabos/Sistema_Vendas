import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClienteRepository {
  final String baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/clients/get_all'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar clientes: ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List;
    return list.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/clients/get/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar cliente $id: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> create(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clients/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar cliente: ${response.statusCode}');
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clients/put/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar cliente $id: ${response.statusCode}');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clients/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar cliente $id: ${response.statusCode}');
    }
  }
}
