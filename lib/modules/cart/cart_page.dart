import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../store/cart_store.dart';
import '../../store/produto_store.dart';
import '../../modules/venda/venda_controller.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class CartPage extends StatefulWidget {
  final String email;
  const CartPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = Modular.get<CartStore>();
  final vendaController = Modular.get<VendaController>();
  final produtoStore = Modular.get<ProdutoStore>();

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text('Carrinho'),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: _isSubmitting ? null : _finalizarVenda,
          child: _isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Finalizar Venda'),
        ),
      ),
    );
  }

  Future<void> _finalizarVenda() async {
    setState(() => _isSubmitting = true);

    final items = cart.cartItems.map((e) {
      final p = e['product'];
      final qty = e['quantity'] as int;
      return {
        'id_produto': p['id_produto'],
        'quantidade': qty,
        'subtotal': (p['preco'] as num) * qty,
      };
    }).toList();

    final total = items.fold<double>(
      0,
      (sum, i) => sum + (i['subtotal'] as num).toDouble(),
    );

    try {
      await vendaController.salvarVenda(
        idVendedor: 7,
        idCliente: 7,
        total: total,
        desconto: 0,
        items: items,
      );

      // Alterar aqui; 

      for (var e in cart.cartItems) {
        final p = e['product'];
        final qty = e['quantity'] as int;
        await produtoStore.decrementStock(p['id_produto'] as int, qty);
      }

      cart.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda emitida com sucesso!')),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      Modular.to.pushReplacementNamed(
        '/catalog/',
        arguments: {'email': widget.email},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível emitir a venda:\n$e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
