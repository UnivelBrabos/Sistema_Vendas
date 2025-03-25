import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<int?> showQuantityDialog(
    BuildContext context, String productName, int availableStock) async {
  final TextEditingController controller = TextEditingController();
  return showDialog<int>(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return AlertDialog(
        title: Text("Digite a quantidade de $productName"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: "Quantidade",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cancela a ação
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text);
              if (quantity == null || quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Informe uma quantidade válida.")),
                );
                return;
              }
              if (quantity > availableStock) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Quantidade excede o estoque disponível ($availableStock).")),
                );
                return;
              }
              Navigator.of(context).pop(quantity);
            },
            child: const Text("Confirmar"),
          ),
        ],
      );
    },
  );
}
