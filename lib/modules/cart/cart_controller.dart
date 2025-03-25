import 'package:flutter_modular/flutter_modular.dart';
import '../../store/cart_store.dart';

class CartController {
  final cartStore = Modular.get<CartStore>();

//finalizar compra
  Future<void> finalizarCompra() async {
    cartStore.clearCart();
  }
}
