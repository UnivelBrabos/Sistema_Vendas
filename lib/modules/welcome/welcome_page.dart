import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class WelcomePage extends StatelessWidget {
  final String email;
  const WelcomePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rawName = email.split('@').first;
    final displayName = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1).toLowerCase()
        : '';
    final initial = displayName.isNotEmpty ? displayName[0] : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo!'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Modular.to.pushNamed(
                  '/profile',
                  arguments: email,
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.success,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Olá, $displayName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mini BI em construção!')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Mini BI'),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Modular.to.pushReplacementNamed('/home');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Catálogo de Produtos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
