// lib/modules/catalog/catalog_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'catalog_page.dart';
import 'catalog_controller.dart';

class CatalogModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => CatalogController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const CatalogPage()),
      ];
}
