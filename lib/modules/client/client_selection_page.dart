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
    final clients = await _repository.getAllClients();
    setState(() {
      _clients = clients;
    });
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
                if (textEditingValue.text.isEmpty) {
                  // Se não há filtro, retorna todos os clientes
                  return _clients;
                }
                return _clients.where((ClienteModel client) => client.nome
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              displayStringForOption: (ClienteModel client) => client.nome,
              onSelected: (ClienteModel selection) {
                setState(() {
                  _selectedClient = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: "Digite o nome do cliente",
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: onEditingComplete,
                );
              },
            ),
            const SizedBox(height: 16),
            _selectedClient != null
                ? Text("Cliente selecionado: ${_selectedClient!.nome}")
                : const Text("Nenhum cliente selecionado"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedClient != null) {
                  // Volta para a tela anterior, retornando o cliente selecionado
                  Modular.to.pop(_selectedClient);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selecione um cliente!")));
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
