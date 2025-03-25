import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = _CartStoreBase with _$CartStore;

abstract class _CartStoreBase with Store {
  @observable
  ObservableList<Map<String, dynamic>> cartItems = ObservableList<Map<String, dynamic>>();

  @action
  void addItem(Map<String, dynamic> product, int quantity) {
    cartItems.add({
      'product': product,
      'quantity': quantity,
    });
  }

  @action
  void removeItem(Map<String, dynamic> product) {
    cartItems.removeWhere((item) => item['product']['id'] == product['id']);
  }

  @action
  void clearCart() {
    cartItems.clear();
  }
}
