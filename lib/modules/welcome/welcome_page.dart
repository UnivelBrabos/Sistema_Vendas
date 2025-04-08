
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WelcomePage extends StatelessWidget {
  final String email;

  const WelcomePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstName = email.split('@').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem-vindo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Olá, $firstName!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mini BI em construção!")),
                );
              },
              child: const Text("Mini BI"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Modular.to.pushReplacementNamed('/home');
              },
              child: const Text("Catálogo de Produtos"),
            ),
          ],
        ),
      ),
    );
  }
}
