import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String? fotoUrl;
  const ProfilePage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  static const _staticUsers = {
    'carlos@gmail.com',
    'saymon@gmail.com',
    'diogo@gmail.com',
    'eder@gmail.com',
  };

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final normalized = email.trim().toLowerCase();

    if (_staticUsers.contains(normalized)) {
      final name = normalized.split('@').first;
      return {
        'nome': name,
        'email': normalized,
        'foto_url': 'lib/assets/macaco/$name.png',
      };
    }

    try {
      return await Supabase.instance.client
          .from('vendedores')
          .select('nome, email, foto_url')
          .eq('email', normalized)
          .maybeSingle();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstNameRaw = email.split('@').first;
    final initial =
        firstNameRaw.isNotEmpty ? firstNameRaw[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snap.data;
          final rawName = (user?['nome'] as String?) ?? firstNameRaw;
          final name = _capitalize(rawName);

          final mail = (user?['email'] as String?) ?? email;

          final supabasePhoto = user?['foto_url'] as String?;
          final rawPhoto =
              (fotoUrl?.isNotEmpty == true ? fotoUrl : supabasePhoto)?.trim();

          ImageProvider? avatarImage;
          if (rawPhoto != null && rawPhoto.isNotEmpty) {
            avatarImage = rawPhoto.startsWith('http')
                ? NetworkImage(rawPhoto)
                : AssetImage(rawPhoto);
          }

          return Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primaryColor,
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? Text(
                              initial,
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mail,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const Divider(height: 32, thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.settings, size: 28),
                      title: const Text('Configurações',
                          style: TextStyle(fontSize: 16)),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Em construção'))),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, size: 28),
                      title: const Text('Sair', style: TextStyle(fontSize: 16)),
                      onTap: () => Modular.to.pushReplacementNamed('/auth'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
