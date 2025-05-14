import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../store/cart_store.dart';

class CartPage extends StatefulWidget {
  final String email;                         
  const CartPage({Key? key, required this.email}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartStore cartStore = Modular.get<CartStore>();
  final String baseUrl = dotenv.env['MIDDLEWARE_URL']!;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Modular.to.pushReplacementNamed(
              '/catalog',
              arguments: widget.email,
            );
          },
        ),
        title: const Text("Carrinho de Compras"),
      ),
      body: Observer(builder: (_) {
        if (cartStore.cartItems.isEmpty) {
          return const Center(child: Text("O carrinho está vazio."));
        }
        return ListView.builder(
          itemCount: cartStore.cartItems.length,
          itemBuilder: (_, index) {
            final item = cartStore.cartItems[index];
            final product = item['product'];
            final qty = item['quantity'] as int;
            return ListTile(
              title: Text(product['nome'] ?? 'Sem nome'),
              subtitle: Text("Quantidade: $qty"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cartStore.removeItem(product),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
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
            onPressed: _isLoading ? null : _finalizarCompra,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Finalizar"),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarCompra() async {
    setState(() => _isLoading = true);
    try {
      final conn = await Connectivity().checkConnectivity();
      if (conn == ConnectivityResult.none) {
        throw Exception('Sem conexão de rede');
      }
      cartStore.clearCart();

      Modular.to.pushReplacementNamed(
        '/catalog',
        arguments: widget.email,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar venda: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
