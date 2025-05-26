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

  /// Busca no Supabase e atualiza o [produtos].
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
      // APLICAR TRATAMENTO DE ERRO :
      print('Erro ao buscar produtos: $e');
    } finally {
      isLoading = false;
    }
  }

  /// Decrementa o estoque localmente e envia update ao Supabase.
  @action
  Future<void> decrementStock(int idProduto, int quantidade) async {
    // 1) Atualiza no array local para refletir imediatamente
    final idx = produtos.indexWhere((p) => p['id_produto'] == idProduto);
    if (idx != -1) {
      final atual = produtos[idx]['estoque'] as int? ?? 0;
      produtos[idx]['estoque'] = (atual - quantidade).clamp(0, double.infinity).toInt();
    }

    // 2) Opcional: persiste no Supabase
    try {
      await supabase
          .from('produtos')
          .update({'estoque': supabase.rpc('estoque - $quantidade')})
          .eq('id_produto', idProduto);
    } catch (e) {
      print('Erro ao atualizar estoque no backend: $e');
      // Se quiser, você pode dar um rollback local aqui
    }
  }
}
