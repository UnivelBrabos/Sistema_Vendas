import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/models/cliente_model.dart';
import 'package:trabalho_vendas_univel/repository/cliente_repository.dart';
import 'package:trabalho_vendas_univel/widgets/dialogs/product_selection_dialog.dart';
import '../../store/produto_store.dart';
import '../../store/cart_store.dart';

class CatalogPage extends StatefulWidget {
  final String email;
  const CatalogPage({Key? key, required this.email}) : super(key: key);

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
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            arguments: widget.email,
          ),
        ),
        title: const Text('Catálogo de Produtos'),
        actions: [
          IconButton(
            onPressed: () => Modular.to.pushReplacementNamed(
              '/cart',
              arguments: widget.email,
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
        onRefresh: () async => await store.fetchProdutos(),
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
                      final clienteRepo = ClienteRepository();
                      final clientes = await clienteRepo.getAllClients();
                      final result = await showDialog<ProductSelectionResult>(
                        context: context,
                        builder: (_) => ProductSelectionDialog(
                          productName: nome,
                          clientes: clientes,
                        ),
                      );
                      if (result != null) {
                        final cartStore = Modular.get<CartStore>();
                        produto['clientesSelecionados'] = result
                            .clientesSelecionados
                            .map((c) => c.toJson())
                            .toList();
                        cartStore.addItem(produto, result.quantidade);
                        Modular.to.pushReplacementNamed(
                          '/cart',
                          arguments: widget.email,
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
