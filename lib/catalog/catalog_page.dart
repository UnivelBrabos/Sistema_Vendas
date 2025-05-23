import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/repository/cliente_repository.dart';
import 'package:trabalho_vendas_univel/widgets/dialogs/product_selection_dialog.dart';
import '../../store/produto_store.dart';
import '../../store/cart_store.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class CatalogPage extends StatefulWidget {
  final String email;
  final String? fotoUrl;
  const CatalogPage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ProdutoStore store = ProdutoStore();

  @override
  void initState() {
    super.initState();
    store.fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pushReplacementNamed(
            '/welcome',
            arguments: {
              'email': widget.email,
              'fotoUrl': widget.fotoUrl,
            },
          ),
        ),
        title: const Text('Catálogo de Produtos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
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
                backgroundImage: widget.fotoUrl != null
                    ? AssetImage(widget.fotoUrl!)
                    : null,
                child: widget.fotoUrl == null
                    ? Text(
                        widget.email[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Modular.to.pushNamed(
              '/cart',
              arguments: {
                'email': widget.email,
                'fotoUrl': widget.fotoUrl,
              },
            ),
            icon: Image.asset(
              'lib/assets/images/carrinho.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => store.fetchProdutos(),
        child: Observer(
          builder: (_) {
            if (store.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (store.produtos.isEmpty) {
              return const Center(child: Text('Nenhum produto encontrado.'));
            }
            return ListView.builder(
              itemCount: store.produtos.length,
              itemBuilder: (_, i) {
                final p = store.produtos[i];
                final nome = p['nome'] ?? 'Sem nome';
                final preco = p['preco'] ?? 0;
                final estoque = p['estoque'] ?? 0;
                return ListTile(
                  title: Text(nome),
                  subtitle: Text('R\$ $preco | Estoque: $estoque'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () async {
                      final clientes = await ClienteRepository().getAllClients();
                      final result = await showDialog<ProductSelectionResult>(
                        context: context,
                        builder: (_) => ProductSelectionDialog(
                          productName: nome,
                          clientes: clientes,
                        ),
                      );
                      if (result != null) {
                        final cart = Modular.get<CartStore>();
                        p['quantidade'] = result.quantidade;
                        cart.addItem(p, result.quantidade);
                        Modular.to.pushReplacementNamed(
                          '/cart',
                          arguments: {
                            'email': widget.email,
                            'fotoUrl': widget.fotoUrl,
                          },
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
