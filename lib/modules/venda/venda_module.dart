import 'package:flutter_modular/flutter_modular.dart';
import '../../repository/venda_repository.dart';
import '../../repository/itens_venda_repository.dart';
import '../../store/venda_store.dart';
import 'venda_controller.dart';
import 'venda_page.dart';
import 'sales_page.dart';
import 'sale_detail_page.dart'; 

class VendaModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => VendaRepository()),
        Bind.lazySingleton((i) => ItensVendaRepository()),

        Bind.factory((i) => VendaController(
              i.get<VendaRepository>(),
              i.get<ItensVendaRepository>(),
            )),

        Bind.singleton((i) => VendaStore()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const CreateSalePage(),
        ),

        ChildRoute(
          '/sales',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return SalesPage(
              email: data['email'] as String,
              fotoUrl: data['fotoUrl'] as String?,
            );
          },
        ),

        ChildRoute(
          '/sale_detail',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return SaleDetailPage(
              idVenda: data['idVenda'] as int,
              email: data['email'] as String,
            );
          },
        ),
      ];
}
