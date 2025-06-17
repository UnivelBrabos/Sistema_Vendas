// lib/modules/cart/cart_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_vendas_univel/core/app_colors.dart';

import '../../store/cart_store.dart';
import '../../store/produto_store.dart';
import '../../modules/venda/venda_controller.dart';
import '../../models/cliente_model.dart';
import '../../repository/cliente_repository.dart';

class CartPage extends StatefulWidget {
  final String email;
  const CartPage({Key? key, required this.email}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = Modular.get<CartStore>();
  final vendaController = Modular.get<VendaController>();
  final produtoStore = Modular.get<ProdutoStore>();
  final baseUrl = dotenv.env['MIDDLEWARE_URL']!;

  bool _isSubmitting = false;
  bool _loadingClientes = false;
  bool _loadingVendedor = false;

  List<ClienteModel> _clientes = [];
  String? _selectedClienteId;
  int? _vendedorId;

  @override
  void initState() {
    super.initState();
    _fetchVendedorId();
    _loadClientes();
  }

  Future<void> _fetchVendedorId() async {
    setState(() => _loadingVendedor = true);
    try {
      final emailNorm = widget.email.trim().toLowerCase();
      final resp = await http.get(Uri.parse('$baseUrl/sellers/get_all'));
      if (resp.statusCode == 200) {
        final list = (jsonDecode(resp.body) as List).cast<Map<String, dynamic>>();
        final match = list.firstWhere(
          (v) => (v['email'] as String).trim().toLowerCase() == emailNorm,
          orElse: () => <String, dynamic>{},
        );
        if (match.isNotEmpty && match['id_vendedor'] != null) {
          _vendedorId = (match['id_vendedor'] as num).toInt();
        } else {
          throw Exception('Vendedor não encontrado no middleware.');
        }
      } else {
        throw Exception('Erro GET sellers: ${resp.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter id_vendedor: $e')),
      );
    } finally {
      setState(() => _loadingVendedor = false);
    }
  }

  Future<void> _loadClientes() async {
    setState(() => _loadingClientes = true);
    try {
      final raw = await ClienteRepository().getAll();
      _clientes = raw.map((j) => ClienteModel.fromJson(j)).toList();
      if (_clientes.isNotEmpty) {
        _selectedClienteId = _clientes.first.idCliente.toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    } finally {
      setState(() => _loadingClientes = false);
    }
  }

  Future<void> _finalizarVenda() async {
    if (_vendedorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aguardando autenticação...')),
      );
      return;
    }
    if (_selectedClienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final items = cart.cartItems.map((e) {
      final p     = e['product'] as Map<String, dynamic>;
      final qty   = e['quantity'] as int;
      final price = (p['preco'] as num).toDouble();
      return {
        'id_produto': p['id_produto'] as int,
        'quantidade': qty,
        'subtotal'  : price * qty,
      };
    }).toList();

    final total = items.fold<double>(
      0,
      (sum, it) => sum + (it['subtotal'] as double),
    );

    try {
      await vendaController.salvarVenda(
        idVendedor: _vendedorId!,
        idCliente : int.parse(_selectedClienteId!),
        total     : total,
        desconto  : 0,
        items     : items,
      );

      for (final it in items) {
        await produtoStore.decrementStock(
          it['id_produto'] as int,
          it['quantidade'] as int,
        );
      }

      await produtoStore.fetchProdutos();
      cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda emitida com sucesso!')),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Modular.to.pushReplacementNamed(
        '/minhas_vendas',
        arguments: {'email': widget.email},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao emitir venda: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingVendedor || _loadingClientes) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final total = cart.cartItems.fold<double>(
      0,
      (sum, e) {
        final p     = e['product'] as Map<String, dynamic>;
        final qty   = e['quantity'] as int;
        final price = (p['preco'] as num).toDouble();
        return sum + price * qty;
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: _clientes
                  .map((c) => DropdownMenuItem(
                        value: c.idCliente.toString(),
                        child: Text(c.nome),
                      ))
                  .toList(),
              value: _selectedClienteId,
              onChanged: (v) => setState(() => _selectedClienteId = v),
            ),
          ),
          Expanded(
            child: Observer(builder: (_) {
              if (cart.cartItems.isEmpty) {
                return const Center(child: Text('Carrinho vazio'));
              }
              return ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (_, i) {
                  final e    = cart.cartItems[i];
                  final p    = e['product'] as Map<String, dynamic>;
                  final nome = p['nome'] as String;
                  final qty  = e['quantity'] as int;
                  final sub  = (p['preco'] as num).toDouble() * qty;
                  return ListTile(
                    title: Text(nome),
                    subtitle: Text(
                      'Qtd: $qty  •  Subtotal: R\$ ${sub.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => cart.removeItem(p),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: _isSubmitting ? null : _finalizarVenda,
          child: _isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Finalizar Venda'),
        ),
      ),
    );
  }
}
