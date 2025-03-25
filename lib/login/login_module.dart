import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/modules/home/home_page.dart';
import 'login_controller.dart';

class LoginModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory((i) => LoginController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => HomePage()),
      ];
}
