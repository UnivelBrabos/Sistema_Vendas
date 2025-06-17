import 'catalog_store.dart';

class CatalogController {
  final CatalogStore store = CatalogStore();

  Future<void> loadProducts() async {
    await store.fetchProducts();
  }
}
