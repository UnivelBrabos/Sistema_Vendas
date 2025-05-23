import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../store/cart_store.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class CartPage extends StatefulWidget {
  final String email;
  final String? fotoUrl;
  const CartPage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = Modular.get<CartStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Modular.to.pushReplacementNamed(
            '/catalog',
            arguments: {
              'email': widget.email,
              'fotoUrl': widget.fotoUrl,
            },
          ),
        ),
        title: const Text('Carrinho'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Modular.to.pushNamed(
                '/profile',
                arguments: {
                  'email': widget.email,
                  'fotoUrl': widget.fotoUrl,
                },
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.success,
                backgroundImage:
                    widget.fotoUrl != null ? AssetImage(widget.fotoUrl!) : null,
                child: widget.fotoUrl == null
                    ? Text(
                        widget.email[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        if (cart.cartItems.isEmpty) {
          return const Center(child: Text('Carrinho vazio'));
        }
        return ListView.builder(
          itemCount: cart.cartItems.length,
          itemBuilder: (_, i) {
            final item = cart.cartItems[i];
            final prod = item['product'];
            final qty = item['quantity'] as int;
            return ListTile(
              title: Text(prod['nome'] ?? ''),
              subtitle: Text('Qtd: $qty'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cart.removeItem(prod),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // limpa o carrinho e volta para catálogo
            cart.clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Compra finalizada!')),
            );
            Modular.to.pushReplacementNamed(
              '/catalog',
              arguments: {
                'email': widget.email,
                'fotoUrl': widget.fotoUrl,
              },
            );
          },
          child: const Text('Finalizar'),
        ),
      ),
    );
  }
}
