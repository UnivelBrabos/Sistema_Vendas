import 'package:flutter_modular/flutter_modular.dart';
import 'catalog_page.dart';

class CatalogModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return CatalogPage(
              email: data['email'] as String,
              fotoUrl: data['fotoUrl'] as String?,
            );
          },
        ),
      ];
}
