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

  @action
  void addItem(Map<String, dynamic> product, int quantity) {
    cartItems.add({ 'product': product, 'quantity': quantity });
  }

  @action
  void removeItem(Map<String, dynamic> product) {
    cartItems.removeWhere((item) => item['product']['id_produto'] == product['id_produto']);
  }

  @action
  void clearCart() {
    cartItems.clear();
  }
}