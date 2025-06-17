import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ItensVendaRepository {
  static final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  Future<void> insertItem(Map<String, dynamic> itemJson) async {
    final uri = Uri.parse('$_baseUrl/sales_items/post');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(itemJson),
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Erro ao inserir item: [${resp.statusCode}] ${resp.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllItens() async {
    final uri = Uri.parse('$_baseUrl/sales_items/get_all');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar itens de venda: [${resp.statusCode}] ${resp.body}');
    }
    final dataList = jsonDecode(resp.body) as List<dynamic>;
    return dataList.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> fetchItemById(int idItem) async {
    final uri = Uri.parse('$_baseUrl/sales_items/get/$idItem');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar item $idItem: [${resp.statusCode}] ${resp.body}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchItensPorVenda(int idVenda) async {
    final uriByVenda = Uri.parse('$_baseUrl/sales_items/get_by_venda/$idVenda');
    final respByVenda = await http.get(uriByVenda);
    if (respByVenda.statusCode == 200) {
      final listaJson = jsonDecode(respByVenda.body) as List<dynamic>;
      return listaJson.map((item) => item as Map<String, dynamic>).toList();
    }
    final all = await fetchAllItens();
    return all.where((item) => (item['id_venda'] as num).toInt() == idVenda).toList();
  }
}
