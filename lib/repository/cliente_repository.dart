import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final supabase = Supabase.instance.client;

  Future<List<ClienteModel>> getAllClients() async {
    final response = await supabase
        .from('clientes')
        .select()
        .order('nome'); 

    final List data = response;
    return data.map((json) => ClienteModel.fromJson(json)).toList();
  }
}
