import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trabalho_vendas_univel/models/cliente_model.dart';

class ProductSelectionResult {
  final List<ClienteModel> clientesSelecionados;
  final int quantidade;

  ProductSelectionResult({
    required this.clientesSelecionados,
    required this.quantidade,
  });
}

class ProductSelectionDialog extends StatefulWidget {
  final String productName; // Nome do produto para exibição
  final List<ClienteModel> clientes; // Lista de clientes disponíveis

  const ProductSelectionDialog({
    Key? key,
    required this.productName,
    required this.clientes,
  }) : super(key: key);

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  // Mapa para manter controle dos checkboxes dos clientes (id_cliente -> bool)
  final Map<int, bool> _selectedClients = {};
  int _quantidade = 0;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente, nenhum cliente selecionado
    for (var client in widget.clientes) {
      _selectedClients[client.idCliente] = false;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Selecione Clientes e Quantidade para ${widget.productName}"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lista de checkboxes para cada cliente
            const Text("Selecione os clientes:"),
            ...widget.clientes.map((client) {
              return CheckboxListTile(
                title: Text(client.nome),
                value: _selectedClients[client.idCliente],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedClients[client.idCliente] = value ?? false;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 16),
            // Campo para quantidade
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Informe a quantidade",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _quantidade = int.tryParse(value) ?? 0;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancela a operação
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            // Validação simples
            if (_quantidade <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Informe uma quantidade válida.")),
              );
              return;
            }
            final clientesSelecionados = widget.clientes.where((client) => _selectedClients[client.idCliente] == true).toList();
            if (clientesSelecionados.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Selecione pelo menos um cliente.")),
              );
              return;
            }
            // Retorna o resultado do diálogo
            Navigator.of(context).pop(ProductSelectionResult(
              clientesSelecionados: clientesSelecionados,
              quantidade: _quantidade,
            ));
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}
