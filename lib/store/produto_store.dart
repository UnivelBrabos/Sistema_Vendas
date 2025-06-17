import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStoreBase with _$ProdutoStore;

abstract class _ProdutoStoreBase with Store {
  late final String baseUrl;

  _ProdutoStoreBase() {
    baseUrl = dotenv.env['MIDDLEWARE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      print('⚠️ MIDDLEWARE_URL não configurado no .env');
    }
  }

  @observable
  ObservableList<Map<String, dynamic>> produtos = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchProdutos() async {
    isLoading = true;
    final endpoint = '$baseUrl/products/get_all';
    print('→ Buscando produtos em: $endpoint');

    try {
      final response = await http.get(Uri.parse(endpoint));
      print('→ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        produtos = ObservableList.of(
          list.map((item) => item as Map<String, dynamic>).toList(),
        );
        print('→ Total de produtos carregados: ${produtos.length}');
      } else {
        print('🔴 Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Erro de conexão ao buscar produtos: $e');
    } finally {
      isLoading = false;
    }
  }
}
