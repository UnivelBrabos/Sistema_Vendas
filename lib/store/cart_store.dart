import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cliente_model.dart';

part 'cart_store.g.dart';

class CartStore = _CartStoreBase with _$CartStore;

abstract class _CartStoreBase with Store {
  @observable
  ObservableList<Map<String, dynamic>> cartItems = ObservableList<Map<String, dynamic>>();

  // Flag para sinalizar que uma venda foi concluída
  @observable
  bool vendaConcluida = false;

  @action
  void addItem(Map<String, dynamic> product, int quantity) {
    cartItems.add({'product': product, 'quantity': quantity});
  }

  @action
  void removeItem(Map<String, dynamic> product) {
    cartItems.removeWhere((item) => item['product']['id_produto'] == product['id_produto']);
  }

  @action
  void clearCart() {
    cartItems.clear();
  }

  @action
  Future<void> concluirVenda(String clienteId) async {
    final middlewareUrl = dotenv.env['MIDDLEWARE_URL']?.trim() ?? '';
    if (middlewareUrl.isEmpty) {
      throw Exception('MIDDLEWARE_URL não está definida no .env');
    }
    final url = Uri.parse('\$middlewareUrl/vendas');

    // Payload: lista de itens vendidos e o cliente correspondente
    final payload = {
      'clienteId': clienteId,
      'items': cartItems.map((item) {
        return {
          'produtoId': item['product']['id_produto'],
          'quantidade': item['quantity'],
        };
      }).toList(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      // Venda concluída com sucesso: limpa o carrinho e sinaliza a flag
      clearCart();
      vendaConcluida = true;
    } else {
      throw Exception('Falha ao concluir venda: \${response.body}');
    }
  }

  /// Reseta a flag para futuras vendas
  @action
  void resetVendaFlag() {
    vendaConcluida = false;
  }
}
