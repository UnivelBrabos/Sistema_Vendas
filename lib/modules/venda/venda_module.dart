import 'package:flutter_modular/flutter_modular.dart';
import '../../repository/venda_repository.dart';
import 'venda_controller.dart';
import 'venda_page.dart';

class VendaModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => VendaRepository()),
        Bind.singleton((i) => VendaController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/venda',
          child: (_, __) => VendaPage(),
        ),
      ];
}
