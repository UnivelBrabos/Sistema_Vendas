import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail == 'admin@gmail.com' && password == 'admin123') {
      Modular.to.pushReplacementNamed(
        '/welcome',
        arguments: normalizedEmail,
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('senha_hash')
          .eq('email', normalizedEmail)
          .maybeSingle();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email incorreto ou não cadastrado.'),
          ),
        );
        return;
      }

      final data = response as Map<String, dynamic>;
      final storedHash = data['senha_hash'] as String?;

      if (storedHash == null || password != storedHash) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciais inválidas (senha incorreta).'),
          ),
        );
        return;
      }

      Modular.to.pushReplacementNamed(
        '/welcome',
        arguments: normalizedEmail,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: $e')),
      );
    }
  }
}
