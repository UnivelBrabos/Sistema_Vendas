// lib/modules/cart/cart_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../store/cart_store.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

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
        leading: BackButton(onPressed: () => Modular.to.navigate('/catalog')),
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

      const int idVendedor = 7;
      const int idCliente = 7;
      const String formaPagamento = 'Pix';
      const int desconto = 0;

      // 1) Calcula total dinamicamente
      final double total = cartStore.cartItems.fold<double>(
        0,
        (sum, item) {
          final price = (item['product']['preco'] as num).toDouble();
          final qty = item['quantity'] as int;
          return sum + price * qty;
        },
      );

      // 2) Payload da venda
      final payloadVenda = {
        'id_vendedor': idVendedor,
        'id_cliente': idCliente,
        'forma_pagamento': formaPagamento,
        'total': total,
        'data_venda': DateTime.now().toIso8601String(),
        'desconto': desconto,
      };
      debugPrint('=== PAYLOAD /sales/post ===');
      debugPrint(const JsonEncoder.withIndent('  ').convert(payloadVenda));

      final saleResp = await http.post(
        Uri.parse('$baseUrl/sales/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payloadVenda),
      );
      debugPrint('saleResp.statusCode: ${saleResp.statusCode}');
      debugPrint('saleResp.body: ${saleResp.body}');
      if (saleResp.statusCode != 200 && saleResp.statusCode != 201) {
        throw Exception('Erro ao criar venda: ${saleResp.body}');
      }

      // 3) Extrai id_venda
      final saleBody = jsonDecode(saleResp.body) as Map<String, dynamic>;
      final int idVenda =
          (saleBody['Vendas']['data'] as List).first['id_venda'] as int;

      // 4) Envia cada item
      for (final item in cartStore.cartItems) {
        final p = item['product'];
        final qty = item['quantity'] as int;
        final subtotal = (p['preco'] as num).toDouble() * qty;
        final lote = p['lote'] as int; 

        final itemJson = {
          'id_venda': idVenda,
          'id_produto': p['id_produto'],
          'quantidade': qty,
          'quantidade_lote': lote,    
          'subtotal': subtotal,
        };
        debugPrint('=== PAYLOAD /sales_items/post ===');
        debugPrint(const JsonEncoder.withIndent('  ').convert(itemJson));

        final itemResp = await http.post(
          Uri.parse('$baseUrl/sales_items/post'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(itemJson),
        );
        debugPrint('itemResp.statusCode: ${itemResp.statusCode}');
        debugPrint('itemResp.body: ${itemResp.body}');
        if (itemResp.statusCode != 200 && itemResp.statusCode != 201) {
          throw Exception('Erro ao inserir item: ${itemResp.body}');
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda emitida com sucesso!')),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      cartStore.clearCart();
      Modular.to.navigate('/catalog');
    } catch (e) {
      debugPrint('❌ Erro ao finalizar venda: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao finalizar venda: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
