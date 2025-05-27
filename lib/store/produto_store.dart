import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStoreBase with _$ProdutoStore;

abstract class _ProdutoStoreBase with Store {
  final supabase = Supabase.instance.client;

  @observable
  ObservableList<Map<String, dynamic>> produtos = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchProdutos() async {
    isLoading = true;
    try {
      final resp = await supabase
          .from('produtos')
          .select()
          .order('nome', ascending: true);
      final list = (resp as List).cast<Map<String, dynamic>>();
      produtos = ObservableList.of(list);
    } catch (e) {
      debugPrint('Erro ao buscar produtos: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> decrementStock(int idProduto, int quantidade) async {
    final idx = produtos.indexWhere((p) => p['id_produto'] == idProduto);
    if (idx == -1) return;

    final atual = produtos[idx]['estoque'] as int? ?? 0;
    final novoEstoque = (atual - quantidade).clamp(0, atual);

    produtos[idx]['estoque'] = novoEstoque;

    try {
      await supabase
          .from('produtos')
          .update({'estoque': novoEstoque})
          .eq('id_produto', idProduto);
    } catch (e) {
      debugPrint('Erro ao atualizar estoque no backend: $e');
      produtos[idx]['estoque'] = atual;
    }
  }
}
