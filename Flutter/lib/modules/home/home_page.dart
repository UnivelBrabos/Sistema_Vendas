import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/widgets/dialogs/quantitiy_dialog.dart';
import '../../store/produto_store.dart';
import '../../store/cart_store.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class HomePage extends StatefulWidget {
  final String email;
  final String? fotoUrl;
  const HomePage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    ? (widget.fotoUrl!.startsWith('assets/macaco/')
                        ? AssetImage(widget.fotoUrl!)
                        : NetworkImage(widget.fotoUrl!)) as ImageProvider
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
                      final quantity =
                          await showQuantityDialog(context, nome, estoque);
                      if (quantity != null) {
                        final cartStore = Modular.get<CartStore>();
                        produto['quantidade'] = quantity;
                        cartStore.addItem(produto, quantity);
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
