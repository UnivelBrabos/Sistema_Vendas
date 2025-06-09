import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_vendas_univel/models/venda_model.dart';

class VendaRepository {
  static final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  Future<int> createVenda(VendaModel venda) async {
    final uri = Uri.parse('$_baseUrl/sales/post');
    final bodyJson = {
      'id_vendedor': venda.idVendedor,
      'id_cliente' : venda.idCliente,
      'data_venda' : venda.dataVenda.toIso8601String(),
      'total'      : venda.total,
      'desconto'   : venda.desconto,
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyJson),
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Erro ao criar venda: [${resp.statusCode}] ${resp.body}');
    }
    final body = jsonDecode(resp.body) as Map<String, dynamic>;

    if (body.containsKey('id_venda')) {
      return (body['id_venda'] as num).toInt();
    }

    if (body.containsKey('Vendas')) {
      final dataList = (body['Vendas']['data'] as List).cast<Map<String, dynamic>>();
      return (dataList.first['id_venda'] as num).toInt();
    }

    throw Exception('Resposta inesperada ao criar venda: $body');
  }

  Future<List<Map<String, dynamic>>> fetchAllVendas() async {
    final uri = Uri.parse('$_baseUrl/sales/get');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar vendas: [${resp.statusCode}] ${resp.body}');
    }
    final list = jsonDecode(resp.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchVendaById(int idVenda) async {
    final uri = Uri.parse('$_baseUrl/sales/get/$idVenda');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar venda $idVenda: [${resp.statusCode}] ${resp.body}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}
