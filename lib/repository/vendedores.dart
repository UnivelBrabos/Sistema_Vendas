import 'package:supabase_flutter/supabase_flutter.dart';

class VendedorRepository {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getVendedores() async {
    try {
      final response = await supabase.from('vendedores').select('*');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar vendedores: $e');
    }
  }
}
