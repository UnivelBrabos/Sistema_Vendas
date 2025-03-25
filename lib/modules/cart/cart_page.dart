import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../store/cart_store.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final CartStore cartStore = Modular.get<CartStore>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Modular.to.canPop()) {
              Modular.to.pop();
            }
          },
        ),
        title: const Text("Carrinho de Compras"),
      ),
      body: Observer(
        builder: (_) {
          if (cartStore.cartItems.isEmpty) {
            return const Center(child: Text("O carrinho está vazio."));
          }
          return ListView.builder(
            itemCount: cartStore.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartStore.cartItems[index];
              final product = item['product'];
              final quantity = item['quantity'];

              return ListTile(
                title: Text(product['nome'] ?? 'Sem nome'),
                subtitle: Text("Quantidade: $quantity"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    cartStore.removeItem(product);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(cartStore),
    );
  }

  Widget _buildBottomBar(CartStore cartStore) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Observer(builder: (_) {
            final totalItems = cartStore.cartItems.fold<int>(
              0,
              (sum, item) => sum + (item['quantity'] as int),
            );
            return Text(
              "Total de itens: $totalItems",
              style: const TextStyle(fontSize: 16),
            );
          }),
          ElevatedButton(
            onPressed: () async {
              await _finalizarCompra(cartStore);
            },
            child: const Text("Finalizar"),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarCompra(CartStore cartStore) async {
    cartStore.clearCart();
    if (Modular.to.canPop()) {
      Modular.to.pop();
    }
  }
}
