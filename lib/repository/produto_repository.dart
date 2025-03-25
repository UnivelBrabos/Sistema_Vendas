import 'package:supabase_flutter/supabase_flutter.dart';

class ProdutoRepository {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllProdutos() async {

    final response = await supabase.from('produtos').select('*');
    return List<Map<String, dynamic>>.from(response);
  }
}
