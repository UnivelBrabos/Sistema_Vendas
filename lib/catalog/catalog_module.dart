import 'package:flutter_modular/flutter_modular.dart';
import 'catalog_page.dart';

class CatalogModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) => CatalogPage(email: args.data as String),
        ),
      ];
}
