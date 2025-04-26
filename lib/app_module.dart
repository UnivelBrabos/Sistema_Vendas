import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/modules/client/client_module.dart';
import 'package:trabalho_vendas_univel/modules/welcome/welcome_page.dart';
import 'package:trabalho_vendas_univel/pages/test_route_page.dart';
import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'modules/cart/cart_module.dart';
import 'catalog/catalog_module.dart';
import 'store/cart_store.dart';
import 'modules/venda/venda_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => CartStore()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AuthModule()),
        ChildRoute('/welcome', child: (_, args) => WelcomePage(email: args.data)),
        ModuleRoute('/home', module: HomeModule()),
        ModuleRoute('/catalog', module: CatalogModule()),
        ModuleRoute('/cart', module: CartModule()),
        ChildRoute('/test', child: (_, __) => const TestRoutePage()),
        ModuleRoute('/client', module: ClientModule()),
        ModuleRoute('/venda', module: VendaModule()),

      ];
}
