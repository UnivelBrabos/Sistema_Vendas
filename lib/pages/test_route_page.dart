import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TestRoutePage extends StatelessWidget {
  const TestRoutePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste de Rota"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navega para a tela de seleção de cliente
            Modular.to.pushNamed('/client/select');
          },
          child: const Text("Ir para Seleção de Cliente"),
        ),
      ),
    );
  }
}
