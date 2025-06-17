import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class DashboardPage extends StatefulWidget {
  final String email;
  const DashboardPage({Key? key, required this.email}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String _baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  List<Map<String, dynamic>> _allVendas = [];
  Map<String, String> _vendorNames = {};
  String? _selectedVendorId;

  double _totalVendas = 0;
  String _melhorClienteNome = '—';
  double _melhorClienteGasto = 0;
  List<_VendedorTotal> _dataForChart = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final vendResp = await http.get(Uri.parse('$_baseUrl/sellers/get_all'));
      if (vendResp.statusCode != 200) {
        throw Exception('Erro ao buscar vendedores: ${vendResp.statusCode}');
      }
      final vendList = (jsonDecode(vendResp.body) as List)
          .cast<Map<String, dynamic>>();
      for (var row in vendList) {
        final id = (row['id_vendedor'] as num).toString();
        _vendorNames[id] = row['nome'] as String;
      }

      final vendasResp = await http.get(Uri.parse('$_baseUrl/sales/get_all'));
      if (vendasResp.statusCode != 200) {
        throw Exception('Erro ao buscar vendas: ${vendasResp.statusCode}');
      }
      _allVendas = (jsonDecode(vendasResp.body) as List)
          .cast<Map<String, dynamic>>();

      _applyFilter();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() async {
    final filtered = _selectedVendorId == null
        ? _allVendas
        : _allVendas.where((v) =>
            (v['id_vendedor'] as num).toString() == _selectedVendorId).toList();

    _totalVendas = filtered.fold<double>(
        0, (sum, v) => sum + (v['total'] as num).toDouble());

    final gastosPorCliente = <int, double>{};
    for (var v in filtered) {
      final cid = (v['id_cliente'] as num).toInt();
      gastosPorCliente[cid] = (gastosPorCliente[cid] ?? 0) +
          (v['total'] as num).toDouble();
    }
    if (gastosPorCliente.isNotEmpty) {
      final best = gastosPorCliente.entries
          .reduce((a, b) => a.value >= b.value ? a : b);
      _melhorClienteGasto = best.value;
      final cliResp = await http.get(
        Uri.parse('$_baseUrl/clients/get/${best.key}'),
      );
      if (cliResp.statusCode == 200) {
        final cliJson = jsonDecode(cliResp.body) as Map<String, dynamic>;
        _melhorClienteNome = cliJson['nome'] as String? ?? '—';
      } else {
        _melhorClienteNome = '—';
      }
    } else {
      _melhorClienteNome = '—';
      _melhorClienteGasto = 0;
    }

    final byVendor = <String, double>{};
    for (var v in filtered) {
      final vid = (v['id_vendedor'] as num).toString();
      byVendor[vid] = (byVendor[vid] ?? 0) + (v['total'] as num).toDouble();
    }
    _dataForChart = byVendor.entries
        .map((e) => _VendedorTotal(e.key, e.value))
        .toList();

    setState(() {});
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

    final sections = _dataForChart.map((e) {
      final pct = _totalVendas > 0 ? e.total / _totalVendas * 100 : 0;
      return PieChartSectionData(
        value: e.total,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Vendas'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  decoration:
                      const InputDecoration(labelText: 'Filtrar Vendedor'),
                  value: _selectedVendorId,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos')),
                    ..._vendorNames.entries.map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        )),
                  ],
                  onChanged: (v) {
                    _selectedVendorId = v;
                    _applyFilter();
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Total de Vendas',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          'R\$ ${_totalVendas.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),
                const Text('Participação por Vendedor',
                    style: TextStyle(fontSize: 16)),
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
                ..._dataForChart.map((e) {
                  final pct = _totalVendas > 0 ? e.total / _totalVendas * 100 : 0;
                  final name = _vendorNames[e.vendedor] ?? e.vendedor;
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
                        Expanded(child: Text(name)),
                        Text('${pct.toStringAsFixed(1)}%'),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(height: 32),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Melhor Cliente',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          _melhorClienteNome,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                            'R\$ ${_melhorClienteGasto.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VendedorTotal {
  final String vendedor;
  final double total;
  _VendedorTotal(this.vendedor, this.total);
}
