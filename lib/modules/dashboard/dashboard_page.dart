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

  double _totalVendas = 0;
  String _melhorClienteNome = '—';
  double _melhorClienteGasto = 0;

  List<_VendedorTotal> _ranking = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final userEmail = widget.email.trim().toLowerCase();

      final vend = await supabase
          .from('vendedores')
          .select('id_vendedor')
          .eq('email', userEmail)
          .maybeSingle();
      if (vend == null || vend['id_vendedor'] == null) {
        throw 'Vendedor não encontrado';
      }
      final idVend = (vend['id_vendedor'] as num).toInt();

      final minhasVendas = await supabase
          .from('vendas')
          .select('total')
          .eq('id_vendedor', idVend);
      _totalVendas = (minhasVendas as List)
          .cast<Map<String, dynamic>>()
          .map((row) => (row['total'] as num).toDouble())
          .fold<double>(0.0, (sum, t) => sum + t);

      final vendasList = minhasVendas.cast<Map<String, dynamic>>();
      final gastosPorCliente = <int, double>{};
      for (var v in vendasList) {
        final cid = (v['id_cliente'] as num?)?.toInt() ?? 0;
        final tot = (v['total'] as num).toDouble();
        gastosPorCliente[cid] = (gastosPorCliente[cid] ?? 0) + tot;
      }
      if (gastosPorCliente.isNotEmpty) {
        final best = gastosPorCliente.entries.reduce(
            (a, b) => a.value >= b.value ? a : b);
        _melhorClienteGasto = best.value;
        final cli = await supabase
            .from('clientes')
            .select('nome')
            .eq('id_cliente', best.key)
            .maybeSingle();
        _melhorClienteNome = (cli?['nome'] as String?) ?? '—';
      }

      final allVendas = await supabase
          .from('vendas')
          .select('id_vendedor,total');
      final tmp = <String, double>{};
      for (var v in (allVendas as List).cast<Map<String, dynamic>>()) {
        final vid = (v['id_vendedor'] as num).toInt().toString();
        final tot = (v['total'] as num).toDouble();
        tmp[vid] = (tmp[vid] ?? 0) + tot;
      }
      _ranking = tmp.entries
          .map((e) => _VendedorTotal(e.key, e.value))
          .toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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

    final sections = <PieChartSectionData>[];
    for (var entry in _ranking) {
      final percent = _totalVendas > 0
          ? entry.total / _totalVendas * 100
          : 0.0;
      sections.add(PieChartSectionData(
        value: entry.total,
        title: '${percent.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Vendas'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Total de Vendas', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${_totalVendas.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const Text('Participação por Vendedor', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 4,
                  centerSpaceRadius: 0,
                ),
              ),
            ),

            const SizedBox(height: 16),
            ..._ranking.map((e) {
              final percent = _totalVendas > 0
                  ? e.total / _totalVendas * 100
                  : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Vendedor ${e.vendedor}')),
                    Text('${percent.toStringAsFixed(1)}%'),
                  ],
                ),
              );
            }).toList(),

            const Divider(height: 32),

            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Melhor Cliente', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _melhorClienteNome,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text('R\$ ${_melhorClienteGasto.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendedorTotal {
  final String vendedor;
  final double total;
  _VendedorTotal(this.vendedor, this.total);
}
