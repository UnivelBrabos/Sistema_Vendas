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
  final produtoStore = Modular.get<ProdutoStore>();
  final cart = Modular.get<CartStore>();

  @override
  void initState() {
    super.initState();
    produtoStore.fetchProdutos();
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
        onRefresh: () => produtoStore.fetchProdutos(),
        child: Observer(
          builder: (_) {
            if (produtoStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (produtoStore.produtos.isEmpty) {
              return const Center(child: Text('Nenhum produto encontrado.'));
            }
            return ListView.builder(
              itemCount: produtoStore.produtos.length,
              itemBuilder: (_, index) {
                final p = produtoStore.produtos[index];
                final idProduto = p['id_produto'] as int? ?? 0;
                final nome      = p['nome']        as String? ?? 'Sem nome';
                final preco     = (p['preco'] as num?)?.toDouble() ?? 0.0;
                final estoque   = p['estoque']     as int? ?? 0;

                return ListTile(
                  title: Text(nome),
                  subtitle: Text(
                    'R\$ ${preco.toStringAsFixed(2)}  •  Estoque: $estoque',
                  ),
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
                        final qty = result['quantity'] as int;
                        debugPrint('Adicionando ao carrinho: id_produto=$idProduto, qty=$qty');

                        cart.addItem(
                          {
                            'id_produto': idProduto,
                            'nome'      : nome,
                            'preco'     : preco,
                          },
                          qty,
                        );

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
