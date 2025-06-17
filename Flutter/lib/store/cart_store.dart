import 'dart:async';
import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'cart_store.g.dart';

class CartStore = _CartStoreBase with _$CartStore;

abstract class _CartStoreBase with Store {
  @observable
  ObservableList<Map<String, dynamic>> cartItems = ObservableList.of([]);

  @observable
  bool vendaConcluida = false;

  @observable
  bool isSubmitting = false;  

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
  Future<String?> concluirVenda(String clienteId) async {
    final middlewareUrl = dotenv.env['MIDDLEWARE_URL']?.trim() ?? '';
    if (middlewareUrl.isEmpty) {
      return 'URL de middleware não está configurada.';
    }

    isSubmitting = true;
    try {
      final url = Uri.parse('$middlewareUrl/vendas');
      final payload = {
        'clienteId': clienteId,
        'items': cartItems.map((item) {
          return {
            'produtoId': item['product']['id_produto'],
            'quantidade': item['quantity'],
          };
        }).toList(),
      };

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        clearCart();
        vendaConcluida = true;
        return null;
      } else {
        return 'Falha ao concluir venda: ${response.statusCode}';
      }
    } on TimeoutException {
      return 'Tempo de conexão esgotado. Verifique sua rede ou ngrok.';
    } catch (e) {
      return 'Erro ao conectar ao servidor: $e';
    } finally {
      isSubmitting = false;
    }
  }

  @action
  void resetVendaFlag() {
    vendaConcluida = false;
  }
}
