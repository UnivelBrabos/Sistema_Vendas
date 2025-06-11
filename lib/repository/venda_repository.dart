// lib/repository/venda_repository.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_vendas_univel/models/venda_model.dart';

class VendaRepository {
  static final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  Future<int> createVenda(VendaModel venda) async {
    final uri = Uri.parse('$_baseUrl/sales/post');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_vendedor': venda.idVendedor,
        'id_cliente' : venda.idCliente,
        'data_venda' : venda.dataVenda.toIso8601String(),
        'total'      : venda.total,
        'desconto'   : venda.desconto,
      }),
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Erro ao criar venda: [${resp.statusCode}] ${resp.body}');
    }

    final decoded = jsonDecode(resp.body);
    if (decoded is String) {
      // resposta inútil, vamos tentar fallback
      return _fallbackLastInsertedId();
    }

    if (decoded is List) {
      // resposta em lista, extrai primeiro mapa
      final first = decoded.isNotEmpty ? decoded.first : null;
      if (first is Map<String, dynamic>) {
        final id = _tryExtractId(first);
        if (id != null) return id;
      }
      // sem id, fallback
      return _fallbackLastInsertedId();
    }

    if (decoded is Map<String, dynamic>) {
      final id = _tryExtractId(decoded);
      if (id != null) return id;
      // sem id, fallback
      return _fallbackLastInsertedId();
    }

    // qualquer outro tipo: fallback
    return _fallbackLastInsertedId();
  }

  /// Tenta extrair id_venda dos formatos:
  /// - body['Mensagem']['id_venda']
  /// - body['id_venda']
  /// - body['Vendas']['data'][0]['id_venda']
  int? _tryExtractId(Map<String, dynamic> body) {
    if (body.containsKey('Mensagem')) {
      final msg = body['Mensagem'];
      if (msg is Map<String, dynamic> && msg.containsKey('id_venda')) {
        return (msg['id_venda'] as num).toInt();
      }
    }
    if (body.containsKey('id_venda')) {
      return (body['id_venda'] as num).toInt();
    }
    if (body.containsKey('Vendas')) {
      final vendasMap = body['Vendas'];
      if (vendasMap is Map<String, dynamic> && vendasMap['data'] is List) {
        final list = (vendasMap['data'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty && list.first.containsKey('id_venda')) {
          return (list.first['id_venda'] as num).toInt();
        }
      }
    }
    return null;
  }

  /// Fallback: busca todas as vendas e retorna o maior id_venda
  Future<int> _fallbackLastInsertedId() async {
    final all = await fetchAllVendas();
    if (all.isEmpty) {
      throw Exception('Não foi possível recuperar id da venda (nenhuma venda existente)');
    }
    // pega o maior id_venda
    final maxId = all.map((v) => (v['id_venda'] as num).toInt()).reduce(max);
    return maxId;
  }

  Future<List<Map<String, dynamic>>> fetchAllVendas() async {
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

  Future<Map<String, dynamic>> fetchVendaById(int idVenda) async {
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
}
