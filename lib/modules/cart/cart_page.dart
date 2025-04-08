import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../store/cart_store.dart';
import '../../models/cliente_model.dart';
import '../../models/venda_model.dart';
import '../../models/itens_venda_model.dart';
import '../../models/venda_serializada.dart';

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
            Modular.to.navigate('/catalog');
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
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final online = connectivityResult != ConnectivityResult.none;

      // 2. Crie os objetos para a venda

      // Exemplo: Obtenha o cliente selecionado.
      // Neste exemplo, usamos um cliente dummy; no seu app, esse dado deve vir da seleção do usuário.
      final ClienteModel clienteSelecionado = ClienteModel(
        idCliente: 6,
        nome: "Padaria Seu Silva",
        cnpj: "12.111.123/0001-01",
        telefone: "11966666666",
        endereco: "Rua A, 123",
      );

      // Obtenha os dados do vendedor logado.
      // Aqui usamos um exemplo fixo; no seu app, capture os dados do vendedor durante o login.
      const int idVendedor = 1;

      // Exemplo: Forma de pagamento selecionada (Pix ou Boleto).
      const String formaPagamento = "Pix";

      // Calcule o total da venda com base nos itens do carrinho.
      final double total = cartStore.cartItems.fold<double>(
        0.0,
        (sum, item) {
          final product = item['product'];
          final quantity = item['quantity'] as int;
          final price = (product['preco']?.toDouble() ?? 0.0);
          return sum + (price * quantity);
        },
      );

      // Crie o objeto VendaModel.
      final vendaModel = VendaModel(
        idVendedor: idVendedor,
        idCliente: clienteSelecionado.idCliente,
        formaPagamento: formaPagamento,
        total: total,
        dataVenda: DateTime.now(),
      );

      // Crie a lista de ItensVendaModel a partir dos itens do carrinho.
      final List<ItensVendaModel> itensVenda = cartStore.cartItems.map((item) {
        final product = item['product'];
        final quantity = item['quantity'] as int;
        final price = (product['preco']?.toDouble() ?? 0.0);
        return ItensVendaModel(
          idProduto: product['id_produto'], // ajuste conforme sua chave primária do produto
          quantidade: quantity,
          subtotal: price * quantity,
        );
      }).toList();

      // Crie o objeto VendaSerializada com a estrutura esperada pelo middleware.
      final vendaSerializada = VendaSerializada(
        clientes: [clienteSelecionado],
        venda: vendaModel,
        itensVenda: itensVenda,
      );

      // Serializa para JSON no formato exato esperado.
      final String jsonVenda = jsonEncode(vendaSerializada.toJson());
      print("JSON da venda: $jsonVenda");

      if (online) {
        // 3. Se online, envie o JSON para o middleware.
        final response = await http.post(
          Uri.parse("https://seu-endpoint-middleware.com/emissao"),
          headers: {"Content-Type": "application/json"},
          body: jsonVenda,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(Modular.routerDelegate.navigatorKey.currentContext!)
              .showSnackBar(const SnackBar(content: Text('Venda emitida com sucesso!')));
        } else {
          throw Exception("Erro do middleware: ${response.body}");
        }
      } else {
        // 4. Se offline, salve o JSON localmente (ex.: usando SQLite) para reenvio posterior.
        ScaffoldMessenger.of(Modular.routerDelegate.navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Sem conexão. Venda salva offline para envio posterior.')));
        // TODO: Implemente o salvamento no SQLite.
      }
    } catch (e) {
      ScaffoldMessenger.of(Modular.routerDelegate.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Erro ao finalizar venda: $e')));
    } finally {
      // 5. Limpa o carrinho e navega de volta para o catálogo
      cartStore.clearCart();
      Modular.to.navigate('/catalog');
    }
  }
}
