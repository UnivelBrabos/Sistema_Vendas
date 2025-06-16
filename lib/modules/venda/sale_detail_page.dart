import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final supabase = Supabase.instance.client;

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
      final vendaRow = await supabase
        .from('vendas')
        .select('id_vendedor, id_cliente, data_venda, total, desconto')
        .eq('id_venda', widget.idVenda)
        .maybeSingle();

      if (vendaRow == null) throw 'Venda não encontrada';

      final idVendedor = (vendaRow['id_vendedor'] as num).toInt();
      final idCliente = (vendaRow['id_cliente'] as num).toInt();
      _dataVenda = DateTime.parse(vendaRow['data_venda'] as String);
      _total     = (vendaRow['total'] as num).toDouble();
      _desconto  = (vendaRow['desconto'] as num).toInt();

      final vendRow = await supabase
        .from('vendedores')
        .select('nome')
        .eq('id_vendedor', idVendedor)
        .maybeSingle();
      _nomeVendedor = vendRow?['nome'] as String? ?? '—';

      final cliRow = await supabase
        .from('clientes')
        .select('nome')
        .eq('id_cliente', idCliente)
        .maybeSingle();
      _nomeCliente = cliRow?['nome'] as String? ?? '—';

      var itensResp = await supabase
        .from('itens_venda')
        .select('id_produto, quantidade_lote, subtotal')
        .eq('id_venda', widget.idVenda);

      final rawItens = (itensResp as List).cast<Map<String, dynamic>>();

      final produtoIds = rawItens
          .map((e) => (e['id_produto'] as num).toInt())
          .toSet()
          .toList();

      List<Map<String, dynamic>> prodsList = [];
      if (produtoIds.isNotEmpty) {
        final idsCsv = produtoIds.join(',');
        var prodsResp = await supabase
          .from('produtos')
          .select('id_produto, nome')
          .filter('id_produto', 'in', '($idsCsv)');

        prodsList = (prodsResp as List).cast<Map<String, dynamic>>();
      }

      final prodsMap = {
        for (var p in prodsList) (p['id_produto'] as int): p['nome'] as String
      };

      _itens = rawItens.map((e) {
        final pid = (e['id_produto'] as num).toInt();
        return _ItemVenda(
          nomeProduto: prodsMap[pid] ?? 'Produto #$pid',
          quantidade: (e['quantidade_lote'] as num).toInt(),
          subtotal: (e['subtotal'] as num).toDouble(),
        );
      }).toList();

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Detalhe da Venda')),
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
                  ]),
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
