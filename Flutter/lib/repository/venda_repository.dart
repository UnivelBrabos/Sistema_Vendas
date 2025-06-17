import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_vendas_univel/models/venda_model.dart';

class VendaRepository {
  final String _baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  Future<int> createVenda(VendaModel venda) async {
    final uri = Uri.parse('$_baseUrl/sales/post');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(venda.toJson()),
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Erro ao criar venda: [${resp.statusCode}] ${resp.body}');
    }

    print('→ createVenda response: ${resp.body}');
    final decoded = jsonDecode(resp.body);

    final directId = _extractId(decoded);
    if (directId != null) {
      return directId;
    }

    final all = await getAll();
    final ids = all
        .map((v) => _extractId(v))
        .where((id) => id != null)
        .cast<int>()
        .toList();

    if (ids.isEmpty) {
      throw Exception('Não foi possível determinar o ID de venda (lista vazia)');
    }
    return ids.reduce(max);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final uri = Uri.parse('$_baseUrl/sales/get_all');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar vendas: [${resp.statusCode}] ${resp.body}');
    }
    final list = jsonDecode(resp.body);
    if (list is! List) {
      throw Exception('Esperado lista, mas veio ${list.runtimeType}');
    }
    return (list as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getById(int idVenda) async {
    final uri = Uri.parse('$_baseUrl/sales/get/$idVenda');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar venda $idVenda: [${resp.statusCode}] ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Esperado objeto JSON, mas veio ${decoded.runtimeType}');
    }
    return decoded;
  }

  int? _extractId(dynamic data) {
    if (data is Map<String, dynamic>) {
      final raw = data['id_venda'] ?? data['sale_id'] ?? data['id'];
      if (raw is num) return raw.toInt();
      if (raw is String && int.tryParse(raw) != null) {
        return int.parse(raw);
      }
    }
    return null;
  }
}
