import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';
import 'venda_controller.dart';

class CreateSalePage extends StatelessWidget {
  const CreateSalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<VendaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            try {
              await controller.salvarVenda(
                idVendedor: 1,
                idCliente: 2,
                total: 123.45,
                desconto: 0, items: [],
                //Ver como que isso vai ficar ajustado
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Venda criada com sucesso!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao criar venda: $e')),
              );
            }
          },
          child: const Text(
            'Finalizar Venda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
