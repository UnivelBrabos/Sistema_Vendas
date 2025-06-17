import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class ProductService {
  final _baseUrl = dotenv.get('MIDDLEWARE_URL');

  Future<List<Product>> fetchProducts() async {
    final resp = await http.get(Uri.parse('$_baseUrl/product/get'));
    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar produtos: ${resp.statusCode}');
    }
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final data = body['produtos']['data'] as List<dynamic>;
    return data.map((j) => Product.fromJson(j)).toList();
  }
}
