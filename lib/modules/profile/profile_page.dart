import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  const ProfilePage({Key? key, required this.email}) : super(key: key);

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('vendedores')
          .select('nome, email')
          .eq('email', email.trim().toLowerCase())
          .maybeSingle();
      return response;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = email.split('@').first;
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = snapshot.data ?? {
            'nome': firstName,
            'email': email,
          };
          final name = user['nome'] as String;
          final emailDisplay = user['email'] as String;

          return Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primaryColor,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      emailDisplay,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(height: 32, thickness: 1),

                    ListTile(
                      leading: const Icon(Icons.settings, size: 28),
                      title: const Text(
                        'Configurações',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Em construção'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, size: 28),
                      title: const Text(
                        'Sair',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Modular.to.navigate('/auth');
                      },
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
