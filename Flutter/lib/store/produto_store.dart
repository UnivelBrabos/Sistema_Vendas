import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStoreBase with _$ProdutoStore;

abstract class _ProdutoStoreBase with Store {
  final String baseUrl = dotenv.env['MIDDLEWARE_URL'] ?? '';

  @observable
  ObservableList<Map<String, dynamic>> produtos = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchProdutos() async {
    isLoading = true;
    final uri = Uri.parse('$baseUrl/products/get_all');
    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body) as List;
        produtos = ObservableList.of(list.cast<Map<String, dynamic>>());
      } else {
        print('🔴 Erro GET produtos: ${resp.statusCode}');
      }
    } catch (e) {
      print('🔴 Erro conexão GET produtos: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> decrementStock(int idProduto, int qty) async {
    isLoading = true;
    try {
      final getUri  = Uri.parse('$baseUrl/products/get/$idProduto');
      final getResp = await http.get(getUri);
      if (getResp.statusCode != 200) {
        throw Exception('GET produto $idProduto falhou: ${getResp.statusCode}');
      }
      final prod = (jsonDecode(getResp.body) as Map<String, dynamic>);

      final atual = (prod['estoque'] as num).toInt();
      final novo  = (atual - qty).clamp(0, atual);

      final body = {
        'nome'              : prod['nome'],
        'descricao'         : prod['descricao'],
        'preco'             : prod['preco'],
        'estoque'           : novo,
        'lote'              : prod['lote'],
        'categoria_produto' : prod['categoria_produto'],
      };

      final putUri  = Uri.parse('$baseUrl/products/put/$idProduto');
      final putResp = await http.put(
        putUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (putResp.statusCode != 200 && putResp.statusCode != 204) {
        throw Exception('PUT produto $idProduto falhou: ${putResp.statusCode}');
      }

      final idx = produtos.indexWhere((p) => (p['id_produto'] as int) == idProduto);
      if (idx != -1) {
        produtos[idx]['estoque'] = novo;
        produtos = ObservableList.of(produtos);
      }
    } catch (e) {
      print('🔴 Erro em decrementStock: $e');
    } finally {
      isLoading = false;
    }
  }
}
