import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/modules/splash/splash_page.dart';
import 'package:trabalho_vendas_univel/modules/auth/auth_module.dart';
import 'package:trabalho_vendas_univel/modules/welcome/welcome_page.dart';
import 'package:trabalho_vendas_univel/modules/home/home_module.dart';
import 'package:trabalho_vendas_univel/modules/cart/cart_module.dart';
import 'package:trabalho_vendas_univel/modules/profile/profile_module.dart';
import 'package:trabalho_vendas_univel/modules/venda/venda_module.dart';
import 'package:trabalho_vendas_univel/store/cart_store.dart';
import 'package:trabalho_vendas_univel/catalog/catalog_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        // nossa store de carrinho fica disponível em todo app
        Bind.singleton((i) => CartStore()),
      ];

  @override
  List<ModularRoute> get routes => [

        ChildRoute('/', child: (_, __) => const SplashPage()),

        ModuleRoute('/auth', module: AuthModule()),

        ChildRoute(
          '/welcome',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return WelcomePage(
              email: data['email'] as String,
              fotoUrl: data['fotoUrl'] as String?,
            );
          },
        ),


        ModuleRoute('/home', module: HomeModule()),

        ModuleRoute('/catalog', module: CatalogModule()),

        ModuleRoute('/cart', module: CartModule()),

        ModuleRoute('/profile', module: ProfileModule()),

        ModuleRoute('/venda', module: VendaModule()),
      ];
}
