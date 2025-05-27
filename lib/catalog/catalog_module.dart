import 'package:flutter_modular/flutter_modular.dart';
import 'catalog_page.dart';

class CatalogModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) {
            final data = args.data;
            if (data is String) {
              return CatalogPage(email: data);
            }
            final map = data as Map<String, dynamic>;
            return CatalogPage(
              email: map['email'] as String,
              fotoUrl: map['fotoUrl'] as String?,
            );
          },
        ),
      ];
}
