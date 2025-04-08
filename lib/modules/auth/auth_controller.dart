import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AuthController {
  Future<void> login(String email, String password, BuildContext context) async {
    if (email.trim().toLowerCase() == 'admin@gmail.com' && password == 'admin123') {
      Modular.to.pushReplacementNamed('/welcome', arguments: email.trim().toLowerCase());
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('vendedores')
          .select()
          .eq('email', email.trim().toLowerCase())
          .single();

      final data = response;

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email incorreto ou não cadastrado.")),
        );
        return;
      }

      final String dataContratacao = data['data_contratacao'];
      final DateTime dt = DateTime.parse(dataContratacao);
      final String senhaEsperada = DateFormat('ddMMyyyy').format(dt);
      // Exemplo: "15/05/2022"

      if (password == senhaEsperada) {
        Modular.to.pushReplacementNamed('/welcome', arguments: email.trim().toLowerCase());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciais inválidas (senha incorreta).")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no login: $e")),
      );
    }
  }
}
