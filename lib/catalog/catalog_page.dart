import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../store/produto_store.dart';
import '../../store/cart_store.dart';
import 'package:trabalho_vendas_univel/widgets/dialogs/product_selection_dialog.dart';

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
  final store = Modular.get<ProdutoStore>();
  final cart = Modular.get<CartStore>();

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
                final nome = p['nome'] as String? ?? 'Sem nome';
                final preco = (p['preco'] as num?)?.toDouble() ?? 0.0;
                final estoque = p['estoque'] as int? ?? 0;
                return ListTile(
                  title: Text(nome),
                  subtitle: Text('R\$ ${preco.toStringAsFixed(2)} | Estoque: $estoque'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (_) => ProductSelectionDialog(
                          productName: nome,
                          unitPrice: preco,
                        ),
                      );
                      if (result != null) {
                        // Adiciona ao carrinho: produto + quantidade
                        cart.addItem(
                          p,
                          result['quantity'] as int,
                        );
                        // Navega para o carrinho
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
