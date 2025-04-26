import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'venda_controller.dart';

class VendaPage extends StatelessWidget {
  final controller = Modular.get<VendaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Venda')),
      body: Center(
        child: ElevatedButton(
          child: Text('Finalizar Venda'),
          onPressed: () async {
            try {
              await controller.salvarVenda(
                idVendedor: 1,
                idCliente: 2,
                total: 123.45,
                desconto: 0,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Venda criada com sucesso!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}
