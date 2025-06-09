import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../store/cart_store.dart';
import '../../store/produto_store.dart';
import '../../modules/venda/venda_controller.dart';
import '../../models/cliente_model.dart';
import '../../repository/cliente_repository.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

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
      final normalized = widget.email.trim().toLowerCase();
      final res = await Supabase.instance.client
          .from('vendedores')
          .select('id_vendedor')
          .eq('email', normalized)
          .maybeSingle();

      if (res != null && res['id_vendedor'] != null) {
        _vendedorId = res['id_vendedor'] as int;
      } else {
        throw Exception('Vendedor não encontrado na tabela "vendedores".');
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
      _clientes = await ClienteRepository().getAllClients();
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
        const SnackBar(content: Text('Aguardando autenticação do vendedor...')),
      );
      return;
    }
    if (_selectedClienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente antes de continuar.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final itemsComSubtotal = cart.cartItems.map((e) {
      final p = e['product'] as Map<String, dynamic>;
      final precoUnit = (p['preco'] as num?)?.toDouble() ?? 0.0;
      final qty = e['quantity'] as int;
      final sub = precoUnit * qty;
      return {
        'id_produto': p['id_produto'] as int,
        'quantidade': qty,
        'subtotal'  : sub,
      };
    }).toList();

    final totalDaVenda = itemsComSubtotal.fold<double>(
      0,
      (sum, item) => sum + (item['subtotal'] as double),
    );

    try {
      await vendaController.salvarVenda(
        idVendedor: _vendedorId!,
        idCliente: int.parse(_selectedClienteId!),
        total: totalDaVenda,
        desconto: 0,
        items: itemsComSubtotal,
      );

      for (final e in List.from(cart.cartItems)) {
        final p = e['product'] as Map<String, dynamic>;
        final qty = e['quantity'] as int;
        await produtoStore.decrementStock(p['id_produto'] as int, qty);
      }

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
          content: Text('Não foi possível emitir a venda:\n$e'),
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

    final totalGeral = cart.cartItems.fold<double>(
      0,
      (sum, e) {
        final p = e['product'] as Map<String, dynamic>;
        final precoUnit = (p['preco'] as num?)?.toDouble() ?? 0.0;
        final qty = e['quantity'] as int;
        return sum + (precoUnit * qty);
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
              decoration: const InputDecoration(labelText: 'Cliente *'),
              items: _clientes.map((c) {
                return DropdownMenuItem(
                  value: c.idCliente.toString(),
                  child: Text(c.nome),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedClienteId = v),
              value: _selectedClienteId,
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
                  final e = cart.cartItems[i];
                  final p = e['product'] as Map<String, dynamic>;
                  final nome = p['nome'] as String? ?? '';
                  final qty = e['quantity'] as int;
                  final sub = (p['preco'] as num).toDouble() * qty;
                  return ListTile(
                    title: Text(nome),
                    subtitle: Text('Qtd: $qty  •  Subtotal: R\$ ${sub.toStringAsFixed(2)}'),
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
                const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('R\$ ${totalGeral.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
