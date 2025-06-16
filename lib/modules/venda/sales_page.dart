import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class SalesPage extends StatefulWidget {
  final String email;
  final String? fotoUrl;
  const SalesPage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final supabase = Supabase.instance.client;

  late Future<List<Map<String, dynamic>>> _futureVendas;

  double? _minValor;
  int? _clienteSelecionado;
  bool _ultimos5Dias = false;

  List<Map<String, dynamic>> _clientes = [];

  @override
  void initState() {
    super.initState();
    _futureVendas = _fetchAllVendas();
    _loadClientes().then((_) => _loadVendas());
  }

  Future<void> _loadClientes() async {
    final resp = await supabase.from('clientes').select('id_cliente, nome');
    _clientes = (resp as List).cast<Map<String, dynamic>>();
  }

  void _loadVendas() {
    setState(() {
      _futureVendas = _fetchAllVendas(
        minValor: _minValor,
        clienteId: _clienteSelecionado,
        ultimosDias: _ultimos5Dias ? 5 : null,
      );
    });
  }

  Future<List<Map<String, dynamic>>> _fetchAllVendas({
    double? minValor,
    int? clienteId,
    int? ultimosDias,
  }) async {
    var builder =
        supabase.from('vendas').select(); 

    if (minValor != null) {
      builder = builder.gte('total', minValor);
    }
    if (clienteId != null) {
      builder = builder.eq('id_cliente', clienteId);
    }
    if (ultimosDias != null) {
      final cutoff = DateTime.now()
          .subtract(Duration(days: ultimosDias))
          .toIso8601String();
      builder = builder.gte('data_venda', cutoff);
    }

    final resp = await builder.order('data_venda', ascending: false);
    return (resp as List).cast<Map<String, dynamic>>();
  }

  void _openFilterSheet() {
    final valorCtrl = TextEditingController(
      text: _minValor?.toStringAsFixed(2) ?? '',
    );

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Filtrar Vendas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          TextField(
            controller: valorCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onChanged: (v) => setState(() => _clienteSelecionado = v),
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text('Últimos 5 dias'),
            value: _ultimos5Dias,
            onChanged: (v) => setState(() => _ultimos5Dias = v),
          ),
          const SizedBox(height: 12),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                setState(() {
                  final parsed =
                      double.tryParse(valorCtrl.text.replaceAll(',', '.'));
                  _minValor = parsed;
                });
                Navigator.pop(context);
                _loadVendas();
              },
              child: const Text('Aplicar'),
            ),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Vendas'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list), onPressed: _openFilterSheet),
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
                    ? Text(widget.email[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white))
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureVendas,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
                child: Text('Erro ao carregar vendas:\n${snap.error}'));
          }
          final vendas = snap.data ?? [];
          if (vendas.isEmpty) {
            return const Center(child: Text('Nenhuma venda encontrada.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vendas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final v = vendas[i];
              final idVenda = (v['id_venda'] as num).toInt();
              final raw = v['data_venda'];
              final dt = raw is String
                  ? DateTime.parse(raw)
                  : (raw is DateTime
                      ? raw
                      : DateTime.tryParse(raw.toString())!);
              final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(dt);
              final total = (v['total'] as num).toDouble();

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    'Venda #$idVenda em $formattedDate',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Total: R\$ ${total.toStringAsFixed(2)}'),
                  trailing:
                      Icon(Icons.chevron_right, color: AppColors.primaryColor),
                  onTap: () {
                    final idVenda = (v['id_venda'] as num).toInt();
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
          );
        },
      ),
    );
  }
}
