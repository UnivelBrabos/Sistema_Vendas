import 'package:flutter_modular/flutter_modular.dart';
import 'auth_controller.dart';
import 'package:trabalho_vendas_univel/login/login_page.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.factory((i) => AuthController()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => const LoginPage()),
  ];
}
