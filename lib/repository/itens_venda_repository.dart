import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/itens_venda_model.dart';

class ItensVendaRepository {
  static final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  Future<void> insertItem(ItensVendaModel item) async {
    final uri = Uri.parse('$_baseUrl/sales_items/post');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception(
        'Erro ao inserir item: [\${resp.statusCode}] \${resp.body}',
      );
    }
  }
}