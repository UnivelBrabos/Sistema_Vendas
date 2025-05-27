import 'package:flutter_modular/flutter_modular.dart';
import '../../repository/venda_repository.dart';
import '../../repository/itens_venda_repository.dart';
import 'venda_controller.dart';
import 'venda_page.dart';
import 'sales_page.dart';

class VendaModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => VendaRepository()),
        Bind.singleton((i) => ItensVendaRepository()),

        Bind.singleton(
          (i) => VendaController(
            i<VendaRepository>(),
            i<ItensVendaRepository>(),
          ),
        ),
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
      ];
}
