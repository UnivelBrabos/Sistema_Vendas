import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/cliente_model.dart';
import '../../repository/cliente_repository.dart';

class ClientSelectionPage extends StatefulWidget {
  const ClientSelectionPage({Key? key}) : super(key: key);

  @override
  State<ClientSelectionPage> createState() => _ClientSelectionPageState();
}

class _ClientSelectionPageState extends State<ClientSelectionPage> {
  final ClienteRepository _repository = ClienteRepository();
  List<ClienteModel> _clients = [];
  ClienteModel? _selectedClient;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final raw = await _repository.getAll();
      final list = raw.map((m) => ClienteModel.fromJson(m)).toList();
      setState(() {
        _clients = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione um Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Autocomplete<ClienteModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (_clients.isEmpty) return const [];
                if (textEditingValue.text.isEmpty) return _clients;
                return _clients.where((c) => c.nome
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              displayStringForOption: (c) => c.nome,
              onSelected: (c) => setState(() => _selectedClient = c),
              fieldViewBuilder:
                  (ctx, ctrl, focus, onEditComplete) => TextField(
                controller: ctrl,
                focusNode: focus,
                decoration: const InputDecoration(
                  labelText: "Digite o nome do cliente",
                  border: OutlineInputBorder(),
                ),
                onEditingComplete: onEditComplete,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedClient != null)
              Text("Cliente selecionado: ${_selectedClient!.nome}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedClient != null) {
                  Modular.to.pop(_selectedClient);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selecione um cliente!")),
                  );
                }
              },
              child: const Text("Confirmar Seleção"),
            ),
          ],
        ),
      ),
    );
  }
}
