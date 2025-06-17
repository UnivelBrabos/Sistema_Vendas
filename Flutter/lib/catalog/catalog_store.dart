import 'package:mobx/mobx.dart';
import '../../repository/produto_repository.dart';

part 'catalog_store.g.dart';

class CatalogStore = _CatalogStoreBase with _$CatalogStore;

abstract class _CatalogStoreBase with Store {
  final ProdutoRepository repository = ProdutoRepository();

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Map<String, dynamic>> products = ObservableList.of([]);

  @action
  Future<void> fetchProducts() async {
    isLoading = true;
    try {
      final data = await repository.getAll(); 
      products = ObservableList.of(data);
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading = false;
    }
  }
}
