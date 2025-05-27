import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/repository/venda_repository.dart';
import 'package:trabalho_vendas_univel/repository/itens_venda_repository.dart';
import '../../modules/venda/venda_controller.dart';
import 'cart_page.dart';

class CartModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => VendaRepository()),
        Bind.singleton((i) => ItensVendaRepository()),
        Bind.singleton((i) => VendaController(
          i<VendaRepository>(),
          i<ItensVendaRepository>(),
        )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return CartPage(email: data['email'] as String);
          },
        ),
      ];
}
