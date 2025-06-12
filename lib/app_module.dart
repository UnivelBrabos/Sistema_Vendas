// lib/app_module.dart

import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/modules/splash/splash_page.dart';
import 'package:trabalho_vendas_univel/modules/auth/auth_module.dart';
import 'package:trabalho_vendas_univel/modules/welcome/welcome_page.dart';
import 'package:trabalho_vendas_univel/modules/home/home_module.dart';
import 'package:trabalho_vendas_univel/catalog/catalog_module.dart';
import 'package:trabalho_vendas_univel/modules/cart/cart_module.dart';
import 'package:trabalho_vendas_univel/modules/profile/profile_module.dart';
import 'package:trabalho_vendas_univel/modules/venda/venda_module.dart';
import 'package:trabalho_vendas_univel/modules/dashboard/dashboard_page.dart';
import 'package:trabalho_vendas_univel/store/cart_store.dart';
import 'package:trabalho_vendas_univel/store/produto_store.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => CartStore()),
        Bind.singleton((i) => ProdutoStore()),
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

        // Dashboard (Desenvolvimento)
        ChildRoute(
          '/dashboard',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return DashboardPage(
              email: data['email'] as String,
            );
          },
        ),
      ];
}
