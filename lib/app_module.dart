import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/catalog/catalog_module.dart';
import 'package:trabalho_vendas_univel/modules/cart/cart_module.dart';
import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'store/cart_store.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => CartStore()),
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute('/', module: AuthModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/catalog', module: CatalogModule()),
    ModuleRoute('/cart', module: CartModule()),
  ];
}
