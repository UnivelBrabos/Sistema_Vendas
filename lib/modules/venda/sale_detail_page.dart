import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class SaleDetailPage extends StatefulWidget {
  final int idVenda;
  final String email;
  final String? fotoUrl;
  const SaleDetailPage({
    Key? key,
    required this.idVenda,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<SaleDetailPage> createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPage> {
  final String baseUrl = dotenv.env['MIDDLEWARE_URL']!;
  bool _loading = true;
  String? _error;

  DateTime? _dataVenda;
  double? _total;
  int? _desconto;
  String _nomeVendedor = '—';
  String _nomeCliente = '—';
  List<_ItemVenda> _itens = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final saleResp = await http.get(
        Uri.parse('$baseUrl/sales/get/${widget.idVenda}'),
      );
      if (saleResp.statusCode != 200) {
        throw Exception('Erro ao buscar venda: ${saleResp.statusCode}');
      }
      final venda = jsonDecode(saleResp.body) as Map<String, dynamic>;
      final idVendedor = (venda['id_vendedor'] as num).toInt();
      final idCliente  = (venda['id_cliente'] as num).toInt();
      _dataVenda = DateTime.parse(venda['data_venda'] as String);
      _total     = (venda['total'] as num).toDouble();
      _desconto  = (venda['desconto'] as num).toInt();

      final vendResp = await http.get(
        Uri.parse('$baseUrl/sellers/get/$idVendedor'),
      );
      if (vendResp.statusCode == 200) {
        final vendJson = jsonDecode(vendResp.body) as Map<String, dynamic>;
        _nomeVendedor = vendJson['nome'] as String? ?? '—';
      }

      final cliResp = await http.get(
        Uri.parse('$baseUrl/clients/get/$idCliente'),
      );
      if (cliResp.statusCode == 200) {
        final cliJson = jsonDecode(cliResp.body) as Map<String, dynamic>;
        _nomeCliente = cliJson['nome'] as String? ?? '—';
      }

      final itensResp = await http.get(
        Uri.parse('$baseUrl/sales_items/get_all'),
      );
      if (itensResp.statusCode != 200) {
        throw Exception('Erro ao buscar itens: ${itensResp.statusCode}');
      }
      final rawList = (jsonDecode(itensResp.body) as List)
          .cast<Map<String, dynamic>>();
      final rawItens = rawList
          .where((e) => (e['id_venda'] as num).toInt() == widget.idVenda)
          .toList();

      final prodsResp = await http.get(
        Uri.parse('$baseUrl/products/get_all'),
      );
      if (prodsResp.statusCode != 200) {
        throw Exception('Erro ao buscar produtos: ${prodsResp.statusCode}');
      }
      final prodsList = (jsonDecode(prodsResp.body) as List)
          .cast<Map<String, dynamic>>();
      final prodsMap = {
        for (var p in prodsList) (p['id_produto'] as int): p['nome'] as String
      };

      _itens = rawItens.map((e) {
        final pid   = (e['id_produto'] as num).toInt();
        final qty   = (e['quantidade_lote'] as num).toInt();
        final sub   = (e['subtotal'] as num).toDouble();
        return _ItemVenda(
          nomeProduto: prodsMap[pid] ?? 'Produto #$pid',
          quantidade: qty,
          subtotal: sub,
        );
      }).toList();

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error   = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhe da Venda')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhe da Venda')),
        body: Center(child: Text('Erro: $_error')),
      );
    }

    final dateStr = _dataVenda != null
        ? DateFormat('dd/MM/yyyy – HH:mm').format(_dataVenda!)
        : '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe da Venda'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Venda #${widget.idVenda}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Data: $dateStr'),
                  Text('Vendedor: $_nomeVendedor'),
                  Text('Cliente: $_nomeCliente'),
                  Text('Total: R\$ ${_total!.toStringAsFixed(2)}'),
                  Text('Desconto: ${_desconto!}%'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Itens da Venda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ..._itens.map((it) => Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(it.nomeProduto),
                  subtitle: Text('Quantidade: ${it.quantidade}'),
                  trailing:
                      Text('Subtotal: R\$ ${it.subtotal.toStringAsFixed(2)}'),
                ),
              )),
        ],
      ),
    );
  }
}

class _ItemVenda {
  final String nomeProduto;
  final int quantidade;
  final double subtotal;

  _ItemVenda({
    required this.nomeProduto,
    required this.quantidade,
    required this.subtotal,
  });
}
