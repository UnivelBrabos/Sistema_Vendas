import 'package:mobx/mobx.dart';
import 'package:trabalho_vendas_univel/repository/produto_repository.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStoreBase with _$ProdutoStore;

abstract class _ProdutoStoreBase with Store {
  final ProdutoRepository repository = ProdutoRepository();

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Map<String, dynamic>> produtos = ObservableList<Map<String, dynamic>>();

  @action
  Future<void> fetchProdutos() async {
    isLoading = true;
    try {
      final data = await repository.getAllProdutos();
      produtos.clear();
      produtos.addAll(data);
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading = false;
    }
  }
}
