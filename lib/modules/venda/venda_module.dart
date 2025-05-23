import 'package:flutter_modular/flutter_modular.dart';
import '../../repository/venda_repository.dart';
import 'venda_controller.dart';
import 'venda_page.dart';
import 'sales_page.dart';

class VendaModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => VendaRepository()),
        Bind.singleton((i) => VendaController(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        // cria nova venda (não precisa de email/foto)
        ChildRoute(
          '/',
          child: (_, __) => const CreateSalePage(),
        ),
        // lista vendas, agora recebe email/foto
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
