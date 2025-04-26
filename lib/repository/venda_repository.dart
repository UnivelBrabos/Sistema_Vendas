import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/venda_model.dart';

class VendaRepository {
  static final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  /// Cria a venda e retorna o ID gerado pelo servidor.
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

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    // Ajuste: Extrai o campo correto que seu middleware retorna
    return data['Vendas']['data'][0]['id_venda'] as int;
  }
}