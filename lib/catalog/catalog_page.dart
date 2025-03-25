import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/widgets/dialogs/quantitiy_dialog.dart';
import '../../store/produto_store.dart';
import '../../store/cart_store.dart';



class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);
  
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
        title: const Text('Catálogo de Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              print("Carrinho clicado");
              Modular.to.navigate('/cart');
            },
            icon: Image.asset(
              'lib/assets/images/carrinho.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await store.fetchProdutos();
        },
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
              itemBuilder: (context, index) {
                final produto = store.produtos[index];
                final nome = produto['nome'] ?? 'Sem nome';
                final preco = produto['preco'] ?? 0;
                final estoque = produto['estoque'] ?? 0;

                return ListTile(
                  title: Text(nome),
                  subtitle: Text('Preço: R\$ $preco | Estoque: $estoque'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () async {
                      final quantity =
                          await showQuantityDialog(context, nome, estoque);
                      if (quantity != null) {
                        print('Produto: $nome, Quantidade: $quantity');
                        final cartStore = Modular.get<CartStore>();
                        cartStore.addItem(produto, quantity);
                        Modular.to.navigate('/cart');
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
