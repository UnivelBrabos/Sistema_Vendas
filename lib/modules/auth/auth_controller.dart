import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final Map<String, String> _staticUsers = {
    'carlos@gmail.com': '123',
    'saymon@gmail.com': '123',
    'diogo@gmail.com': '123',
    'eder@gmail.com': '123',
  };

  Future<void> login(
    String email, 
    String password,
    BuildContext context,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();

    String? fotoUrl;

    if (normalizedEmail == 'admin@gmail.com' && password == 'admin123') {
      fotoUrl = null;
      _goToWelcome(normalizedEmail, fotoUrl);
      return;
    }

    final staticPass = _staticUsers[normalizedEmail];
    if (staticPass != null && password == staticPass) {
      final name = normalizedEmail.split('@').first;
      fotoUrl = 'lib/assets/macaco/$name.png';
      _goToWelcome(normalizedEmail, fotoUrl);
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
          const SnackBar(content: Text('Email incorreto ou não cadastrado.')),
        );
        return;
      }

      final data = response;
      final storedHash = data['senha_hash'] as String?;

      if (storedHash == null || password != storedHash) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas (senha incorreta).')),
        );
        return;
      }

      fotoUrl = null;

      _goToWelcome(normalizedEmail, fotoUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: $e')),
      );
    }
  }

  void _goToWelcome(String email, String? fotoUrl) {
    Modular.to.pushReplacementNamed(
      '/welcome',
      arguments: {
        'email': email,
        'fotoUrl': fotoUrl,
      },
    );
  }
}
