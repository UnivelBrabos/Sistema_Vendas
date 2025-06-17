import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../repository/venda_repository.dart';
import '../../repository/cliente_repository.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class SalesPage extends StatefulWidget {
  final String email;
  final String? fotoUrl;

  const SalesPage({Key? key, required this.email, this.fotoUrl})
      : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final VendaRepository _vendaRepo = VendaRepository();
  final ClienteRepository _clienteRepo = ClienteRepository();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _vendas = [];
  List<Map<String, dynamic>> _clientes = [];

  double? _minValor;
  int? _clienteSelecionado;
  bool _ultimos5Dias = false;

  @override
  void initState() {
    super.initState();
    _loadClientes().then((_) => _loadVendas());
  }

  Future<void> _loadClientes() async {
    try {
      final raw = await _clienteRepo.getAll();
      setState(() {
        _clientes = raw;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    }
  }

  Future<void> _loadVendas() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final all = await _vendaRepo.getAll();
      final now = DateTime.now();
      var filtered = all;

      if (_minValor != null) {
        filtered = filtered
            .where((v) => (v['total'] as num).toDouble() >= _minValor!)
            .toList();
      }
      if (_clienteSelecionado != null) {
        filtered = filtered
            .where(
                (v) => (v['id_cliente'] as num).toInt() == _clienteSelecionado)
            .toList();
      }
      if (_ultimos5Dias) {
        final cutoff = now.subtract(const Duration(days: 5));
        filtered = filtered.where((v) {
          final raw = v['data_venda'] as String;
          final dt = DateTime.parse(raw);
          return dt.isAfter(cutoff);
        }).toList();
      }

      filtered.sort((a, b) {
        final da = DateTime.parse(a['data_venda'] as String);
        final db = DateTime.parse(b['data_venda'] as String);
        return db.compareTo(da);
      });

      setState(() {
        _vendas = filtered;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _openFilterSheet() {
    final valorCtrl = TextEditingController(
      text: _minValor?.toStringAsFixed(2) ?? '',
    );

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filtrar Vendas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valorCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor mínimo (R\$)',
                prefixText: '≥ ',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _clienteSelecionado,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todos')),
                ..._clientes.map((c) => DropdownMenuItem<int?>(
                      value: c['id_cliente'] as int,
                      child: Text(c['nome'] as String),
                    )),
              ],
              onChanged: (v) => setState(() {
                _clienteSelecionado = v;
              }),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Últimos 5 dias'),
              value: _ultimos5Dias,
              onChanged: (v) => setState(() {
                _ultimos5Dias = v;
              }),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _minValor = null;
                      _clienteSelecionado = null;
                      _ultimos5Dias = false;
                    });
                    Navigator.pop(context);
                    _loadVendas();
                  },
                  child: const Text('Limpar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final parsed = double.tryParse(
                      valorCtrl.text.replaceAll(',', '.'),
                    );
                    setState(() {
                      _minValor = parsed;
                    });
                    Navigator.pop(context);
                    _loadVendas();
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text('Erro ao carregar vendas:\n${_error!}'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Vendas'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Modular.to.pushNamed(
                '/profile',
                arguments: {
                  'email': widget.email,
                  'fotoUrl': widget.fotoUrl,
                },
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.success,
                backgroundImage:
                    widget.fotoUrl != null ? AssetImage(widget.fotoUrl!) : null,
                child: widget.fotoUrl == null
                    ? Text(
                        widget.email[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _vendas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final v = _vendas[i];
          final idVenda = (v['id_venda'] as num).toInt();
          final date = DateTime.parse(v['data_venda'] as String);
          final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(date);
          final total = (v['total'] as num).toDouble();

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                'Venda #$idVenda em $formattedDate',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Total: R\$ ${total.toStringAsFixed(2)}'),
              trailing:
                  Icon(Icons.chevron_right, color: AppColors.primaryColor),
              onTap: () {
                Modular.to.pushNamed(
                  '/venda/sale_detail',
                  arguments: {
                    'idVenda': idVenda,
                    'email': widget.email,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
