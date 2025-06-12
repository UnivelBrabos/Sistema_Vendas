import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class DashboardPage extends StatefulWidget {
  final String email;
  const DashboardPage({Key? key, required this.email}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final supabase = Supabase.instance.client;

  Map<String, String> _vendorNames = {};

  double _totalVendas = 0;
  String _melhorClienteNome = '—';
  double _melhorClienteGasto = 0;

  List<_VendedorTotal> _ranking = [];

  String? _selectedVendorId;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final vResp = await supabase
          .from('vendedores')
          .select('id_vendedor, nome');
      for (final row in (vResp as List).cast<Map<String, dynamic>>()) {
        final id = (row['id_vendedor'] as num).toInt().toString();
        final nome = row['nome'] as String;
        _vendorNames[id] = nome;
      }

      final vendLog = await supabase
          .from('vendedores')
          .select('id_vendedor')
          .eq('email', widget.email.trim().toLowerCase())
          .maybeSingle();
      if (vendLog == null || vendLog['id_vendedor'] == null) {
        throw 'Vendedor não encontrado';
      }
      final myId = (vendLog['id_vendedor'] as num).toInt().toString();

      final allVendas = await supabase
          .from('vendas')
          .select('id_vendedor, id_cliente, total');

      _totalVendas = 0;
      final gastosPorCliente = <int,double>{};
      final tmpRanking = <String,double>{};

      for (final rec in (allVendas as List).cast<Map<String, dynamic>>()) {
        final vid = (rec['id_vendedor'] as num).toInt().toString();
        final tot = (rec['total'] as num).toDouble();

        tmpRanking[vid] = (tmpRanking[vid] ?? 0) + tot;

        if (vid == myId) {
          _totalVendas += tot;
          final cid = (rec['id_cliente'] as num).toInt();
          gastosPorCliente[cid] = (gastosPorCliente[cid] ?? 0) + tot;
        }
      }

      _ranking = tmpRanking.entries
          .map((e) => _VendedorTotal(e.key, e.value))
          .toList();

      if (gastosPorCliente.isNotEmpty) {
        final best = gastosPorCliente.entries
            .reduce((a,b) => a.value>=b.value ? a : b);
        _melhorClienteGasto = best.value;
        final cli = await supabase
            .from('clientes')
            .select('nome')
            .eq('id_cliente', best.key)
            .maybeSingle();
        _melhorClienteNome = (cli?['nome'] as String?) ?? '—';
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<_VendedorTotal> get _filteredRanking {
    if (_selectedVendorId == null) return _ranking;
    return _ranking.where((e) => e.vendedor == _selectedVendorId).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Erro: $_error')),
      );
    }

    final data = _filteredRanking;
    final sections = <PieChartSectionData>[];
    for (final entry in data) {
      final pct = _totalVendas > 0
          ? entry.total / _totalVendas * 100
          : 0.0;
      sections.add(
        PieChartSectionData(
          value: entry.total,
          title: '${pct.toStringAsFixed(0)}%',
          radius: 50,
          titleStyle: const TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Vendas'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

          DropdownButtonFormField<String?>(
            decoration: const InputDecoration(labelText: 'Filtrar Vendedor'),
            value: _selectedVendorId,
            items: [
              const DropdownMenuItem(value: null, child: Text('Todos')),
              ..._vendorNames.entries.map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  )),
            ],
            onChanged: (v) => setState(() => _selectedVendorId = v),
          ),
          const SizedBox(height: 16),

          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Text('Total de Vendas', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${_totalVendas.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),

          const Text('Participação por Vendedor', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 4,
                centerSpaceRadius: 0,
              ),
            ),
          ),

          const SizedBox(height: 16),
          ...data.map((e) {
            final pct = _totalVendas > 0
                ? e.total / _totalVendas * 100
                : 0.0;
            final name = _vendorNames[e.vendedor] ?? e.vendedor;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(name)),
                Text('${pct.toStringAsFixed(1)}%'),
              ]),
            );
          }).toList(),

          const Divider(height: 32),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Text('Melhor Cliente', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(_melhorClienteNome,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                Text('R\$ ${_melhorClienteGasto.toStringAsFixed(2)}'),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _VendedorTotal {
  final String vendedor;
  final double total;
  _VendedorTotal(this.vendedor, this.total);
}
