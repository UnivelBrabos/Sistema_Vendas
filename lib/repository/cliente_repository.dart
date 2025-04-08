import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final supabase = Supabase.instance.client;

  Future<List<ClienteModel>> getAllClients() async {
    final response = await supabase
        .from('clientes')
        .select()
        .order('nome'); // Ordena por nome, se desejar

    // Supondo que a resposta é uma List de Maps
    final List data = response;
    return data.map((json) => ClienteModel.fromJson(json)).toList();
  }
}
