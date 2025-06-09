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

  @override
  void initState() {
    super.initState();
    _futureVendas = _fetchAllVendas();
  }

  Future<List<Map<String, dynamic>>> _fetchAllVendas() async {
    final resp = await supabase
        .from('vendas')
        .select()
        .order('data_venda', ascending: false);
    return (resp as List).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Vendas'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureVendas,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro ao carregar vendas:\n${snap.error}'));
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
                  : (raw is DateTime ? raw : DateTime.tryParse(raw.toString())!);
              final formattedDate =
                  DateFormat('dd/MM/yyyy – HH:mm').format(dt);
              final total = (v['total'] as num).toDouble();

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    'Venda #$idVenda em $formattedDate',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Total: R\$ ${total.toStringAsFixed(2)}'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () {
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
